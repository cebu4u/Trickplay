import os, telnetlib, base64, sys, random, json, time, re

from PyQt4.QtGui import *
from PyQt4.QtCore import *
from PyQt4.QtNetwork import  QTcpSocket, QNetworkAccessManager , QNetworkRequest , QNetworkReply
from UI.HorizontalGuideline import Ui_horizGuideDialog
from UI.VerticalGuideline import Ui_vertGuideDialog

def getNextInfo(s) :
    idx = s.find(":")
    info = s[:idx]
    s = s[idx+1:]
    return info, s

VE_JSON_COMMAND = ["getStInfo", "getUIInfo", "repUIInfo", "repStInfo", "repUIInfo", "scrJSInfo", "imageInfo" ]
OtherButton = { "Up":"Down", "Down":"Up", "Left":"Right", "Right":"Left"}

class TrickplayEmulatorManager(QWidget):

    def __init__(self, main=None, parent = None):

        QWidget.__init__(self, parent)

        self.main = main
        self.unsavedChanges = False
        self.contentMoveBlock = False
        self.fscontentMoveBlock = False
        self.addItemToScreens = False
        self.inspector = main._inspector
        self.filesystem = main._ifilesystem
        self._path = os.path.join(self.main.apath, 'VE')
        self.trickplay = QProcess()

        QObject.connect(self.trickplay, SIGNAL('started()'), self.app_started)
        QObject.connect(self.trickplay, SIGNAL('finished(int)'), self.app_finished)
        QObject.connect(self.trickplay, SIGNAL('readyRead()'), self.app_ready_read)

        self.manager = QNetworkAccessManager()
        self.pdata = None
        self.clonelist = []

        self.run()

    def chgStyleName(self, gid, new_name, old_name):
        self.setUIInfo(gid, "style", "WL.Style('"+new_name+"'):set('"+old_name+"')")
        self.getStInfo()
        #self.main.sendLuaCommand("refresh", "_VE_.refresh()")

    def setStyleInfo(self, style_name, property1, property2, property3=None, value=None):
        if property1 == 'name':
            self.main.sendLuaCommand("WL.Style", "WL.Style('"+str(style_name)+"')."+str(property1)+" = '"+str(property2)+"'")
        elif property3 == "style":
            self.main.sendLuaCommand("WL.Style","WL.Style('"+str(style_name)+"')."+str(property2)+"."+str(property1)+" = "+str(value))
        else:
            self.main.sendLuaCommand("WL.Style", "WL.Style('"+str(style_name)+"')."+str(property3)+"."+str(property2)+"."+str(property1)+" = "+str(value))
        #self.main.sendLuaCommand("refresh", "_VE_.refresh()")
        self.getStInfo()

    def setUIInfo(self, gid, property, value, n=None):
        if n:
            self.main.sendLuaCommand("setUIInfo", "_VE_.setUIInfo('"+str(gid)+"','"+str(property)+"','"+str(value)+"',"+str(n)+")")
        else:
            self.main.sendLuaCommand("setUIInfo", "_VE_.setUIInfo('"+str(gid)+"','"+str(property)+"',"+str(value)+")")

        self.inspector.setGid = gid
        self.inspector.setProp = property

    def repStInfo(self):
        self.main.sendLuaCommand("repStInfo", "_VE_.repStInfo()")

    def getStInfo(self):
        self.main.sendLuaCommand("getStInfo", "_VE_.getStInfo()")

    def getUIInfo(self):
        self.main.sendLuaCommand("getUIInfo", "_VE_.getUIInfo()")

    def setPath(self, p):
        self._path = p

    def path(self):
        return self._path

    def app_started(self):
        print "[VE] APP Started"
        self.main.ui.actionEditor.setEnabled(True)

    def deleteClicked(self) :
        self.main.sendLuaCommand("deleteGuideLine", "_VE_.deleteGuideLine()")
        self.GLI_dialog.done(1)

    def app_ready_read(self):
        # Read all available output from the process

        while True:
            # Read one line
            if not self.trickplay.canReadLine():
                break
            # Read one line
            s = self.trickplay.readLine()

            # If the line is null, it means there is nothing more
            # to read during this iteration
            if s.isNull():
                break

            # Convert it to a string and strip the trailing white space
            s = str( s ).rstrip()
            if s[:9] in VE_JSON_COMMAND :
                print "[TP] "+s[:9]
            else :
                print "[TP] "+s

            # Look for the VE_READY line
            if s.find( "VE_READY" ) > -1:
                try:
                    #load setting path !!
                    print "[VE] Current Project : %s"%self.main.currentProject

                    self.ve_ready = True
                    if self.main and self.main.currentProject is None:
                         return
                    elif self.main and self.main.currentProject :
                         if self.main.command == "newProject":
                            self.main.newLayer()
                            self.main.inspector.screens["Default"].append("Layer0")
                            self.main.save()
                         else:
                            self.main.open()
                except:
                    print( "[VE] Failed to obtain ui info" )
                    # Close the process
                    self.trickplay.close()

                settings = QSettings()
                self.main.x = str(settings.value('x').toInt()[0])
                self.main.y = str(settings.value('y').toInt()[0])

                if self.main.x == None or self.main.y == None:
                    self.main.y = str(204)
                    self.main.x = str(338)

                self.main.sendLuaCommand("setScreenLoc", "_VE_.setScreenLoc("+self.main.x+","+self.main.y+")")
                
                self.main.sendLuaCommand("setCurrentProject", "_VE_.setCurrentProject("+"'"+os.path.basename(str(self.main.currentProject))+"  "+self.inspector.currentScreenName+"')")

            else:
                # Output the log line
                sdata = None
                gid = None
                shift = None

                if s is not None and len(s) > 9 :
                    luaCmd= s[:9]
                    if luaCmd == "getUIInfo":
                        self.pdata = json.loads(s[9:])
                    elif luaCmd == "screenLoc":
                        screenLoc = s[9:]
                        sepPos = screenLoc.find(",")
                        self.main.x = screenLoc[:sepPos]
                        self.main.y = screenLoc[sepPos + 1:]
                        settings = QSettings()
                        settings.setValue("x", self.main.x)
                        settings.setValue("y", self.main.y)
                    elif luaCmd == "openV_GLI" or luaCmd =="openH_GLI":
                        org_position = int(s[9:])
                        self.GLI_dialog = QDialog()
                        self.GLI_dialog.setWindowFlags(Qt.WindowStaysOnTopHint)
                        if luaCmd =="openV_GLI":
                            self.GLInspector_ui = Ui_vertGuideDialog()
                        else:
                            self.GLInspector_ui = Ui_horizGuideDialog()

                        self.GLInspector_ui.setupUi(self.GLI_dialog)
                        self.main.sendLuaCommand("getScreenLoc", "_VE_.getScreenLoc()")
                        self.GLI_dialog.setGeometry(int(self.main.x)+400,int(self.main.y)+200, 286, 86)
                        self.GLI_dialog.focusWidget()
                        self.GLInspector_ui.spinBox.setValue(org_position)
                        QObject.connect(self.GLInspector_ui.deleteButton, SIGNAL("clicked()"), self.deleteClicked)

                        if self.GLI_dialog.exec_():
                            new_positon = self.GLInspector_ui.spinBox.value()
                        else:
                            new_positon = "nil"
                        if luaCmd =="openV_GLI":
                            self.main.sendLuaCommand("setVGuideX", "_VE_.setVGuideX("+str(new_positon)+")")
                        else:
                            self.main.sendLuaCommand("setHGuideX", "_VE_.setHGuideY("+str(new_positon)+")")

                    elif luaCmd == "prtObjNme":
                        self.clonelist = s[9:].split()
                    elif luaCmd == "focusInfo":
                        info = s[9:]
                        fgid, info = getNextInfo(info)
                        focus, info = getNextInfo(info)
                        item = self.inspector.search(str(fgid), 'gid')
                        try :
                            if focus[:1] == "T":
                                item['focused'] = True
                            else:
                                item['focused'] = False
                            index = self.inspector.selected (self.inspector.ui.inspector)
                            item = self.inspector.inspectorModel.itemFromIndex(index)
                            if item['gid'] == fgid :
                                if self.inspector.main.command is not "setUIInfo" :
                                    self.inspector.preventChanges = True
                                    self.inspector.propertyFill(item.TPJSON())
                                    self.inspector.preventChanges = False
                        except:
                            pass

                    elif luaCmd == "posUIInfo":
                        posInfo = s[9:]
                        posGid, posInfo = getNextInfo(posInfo)
                        posX, posInfo = getNextInfo(posInfo)
                        posY, posInfo = getNextInfo(posInfo)
                        try:
                            item = self.inspector.search(str(posGid), 'gid')
                            item['position'] = [int(posX), int(posY), 0]

                            if self.inspector.main.command is not "setUIInfo" :
                                self.inspector.preventChanges = True
                                self.inspector.propertyFill(item.TPJSON())
                                self.inspector.preventChanges = False
                            self.unsavedChanges = True
                        except:
                            pass
                    elif luaCmd == "repUIInfo":
                        self.pdata = json.loads(s[9:])
                    elif luaCmd == "repStInfo" :
                        sdata = json.loads(s[9:])
                    elif luaCmd == "getStInfo" :
                        sdata = json.loads(s[9:])
                    elif luaCmd == "clearInsp":
                        gid = (s[9:])
                    elif luaCmd == "focusSet2":
                        focusObjGid = str(s[9:])
                        checkedButton = self.inspector.neighbors.findCheckedButton()
                        focusItem = self.inspector.search(focusObjGid, 'gid')
                        theItem = self.inspector.search(self.inspector.neighbors.gid, 'gid')
                        buttonType =  str(checkedButton.whatsThis()).title()

                        if focusItem is None:
                            checkedButton.setText("empty")
                            self.inspector.neighbors.toggled(False)
                            if OtherButton.has_key(buttonType) :
                                del theItem['neighbors'][buttonType]
                            else:
                                del theItem['neighbors']["Return"]
                        else:
                            focusObjName = focusItem['name']
                            checkedButton.setText(focusObjName)
                            self.inspector.neighbors.toggled(False)
                            if OtherButton.has_key(buttonType) :
                                theItem['neighbors'][buttonType] = focusObjName
                                focusItem['neighbors'][OtherButton[buttonType]] = theItem['name']
                            else:
                                theItem['neighbors']["Return"] = focusObjName
                        self.unsavedChanges = True

                    elif luaCmd == "newui_gid":
                        self.inspector.newgid = str(s[9:])
                        self.unsavedChanges = True
                    elif luaCmd == "openInspc":
                        gid = (s[10:])
                        shift = s[9]
                    elif luaCmd == "scrJSInfo":
                        self.addItemToScreens = True
                        scrData = json.loads(s[9:])
                        self.inspector.screens = {}
                        screenNames = []
                        for i in scrData[0]:
                            if i != "currentScreenName":
                                self.inspector.screens[str(i)]=[]
                                screenNames.append(str(i))
                                for j in scrData[0][i]:
                                    self.inspector.screens[str(i)].append(str(j))
                            else:
                                self.inspector.currentScreenName = scrData[0][i]
                                self.inspector.old_screen_name = "  "

                        while self.inspector.ui.screenCombo.count() > 0 :
                            curIdx = self.inspector.ui.screenCombo.currentIndex()
                            self.inspector.ui.screenCombo.removeItem(curIdx)

                        for scrName in screenNames:
                            if self.inspector.ui.screenCombo.findText(scrName) < 0 and scrName != "_AllScreens":
                                self.inspector.ui.screenCombo.addItem(scrName)

                        self.addItemToScreens = False

                    elif luaCmd == "imageInfo":
                        self.imgData = json.loads(s[9:])
                        self.fscontentMoveBlock = True
                        self.filesystem.buildImageTree(self.imgData)
                        if self.filesystem.orgCnt >= self.filesystem.idCnt and self.filesystem.imageCommand in ["assets", "skins"]:
                            self.main.errorMsg("No new image file was added !")

                        self.filesystem.imageCommand = ""
                        self.fscontentMoveBlock = False
                    else:
                        pass

                    if gid is not None and luaCmd == "clear:Insp":
                        try:
                            result = self.inspector.search(gid, 'gid')
                            if result:
                                print('Found*', result['gid'], result['name'])
                                self.inspector.clearItem(result)
                            else:
                                print("UI Element not found")

                        except:
                            print("error :-(")


                    if gid is not None and luaCmd == "openInspc":
                        try:
                            result = self.inspector.search(gid, 'gid')
                            if result:
                                if shift == "f" :
                                    self.inspector.ui.inspector.selectionModel().clear()

                                self.inspector.selectItem(result, shift)
                                # open Property Tab
                                # self.inspector.ui.tabWidget.setCurrentIndex(1)
                            else:
                                print(result, gid, "---UI Element not found")
                                self.inspector.ui.inspector.clearSelection()
                                return

                        except:
                            print("error :/(")

                    if luaCmd == "repStInfo" or luaCmd == "getStInfo":
                        if self.main.command == "openFile" :
                            return
                        elif self.main.command == "setCurrentProject":
                            pass
                        else:
                            self.inspector.inspectorModel.styleData = sdata
                            self.inspector.preventChanges = True
                            if self.inspector.cbStyle is not None:
                                try:
                                    self.inspector.propertyFill(self.inspector.curData, self.inspector.cbStyle.currentIndex())
                                    self.inspector.expandStyle()
                                except:
                                    pass
                                if self.ve_ready == False :
                                    self.unsavedChanges = True
                                self.ve_ready = False
                            self.inspector.preventChanges = False
                    elif luaCmd == "repUIInfo":
                        self.pdata = self.pdata[0]
                        if self.main.command == "openFile" :
                            return
                        elif self.main.command == "duplicate" or self.main.command == "clone":
                            curLayerItem = self.inspector.search(self.inspector.curLayerGid, 'gid')
                            if not self.inspector.search(self.pdata['gid'], 'gid') :
                                self.inspector.inspectorModel.insertElement(curLayerItem, self.pdata, curLayerItem.TPJSON(), False, True)
                                self.inspector.deselectItems()
                                newItem = self.inspector.search(self.pdata['gid'], 'gid')
                                self.inspector.selectItem(newItem, False)
                            return
                        elif self.main.command == "newLayer" :
                            self.main.command = ""
                            screenItem = self.inspector.search(self.inspector.screenGid, 'gid')
                            self.inspector.inspectorModel.insertElement(screenItem, self.pdata, screenItem.TPJSON(), False, True)
                            self.inspector.deselectItems()
                            newItem = self.inspector.search(self.pdata['gid'], 'gid')
                            self.inspector.selectItem(newItem, False)
                            return
                        elif self.main.command == "insertUIElement" :
                            self.main.command = ""
                            curLayerItem = self.inspector.search(self.inspector.curLayerGid, 'gid')
                            self.inspector.inspectorModel.insertElement(curLayerItem, self.pdata, curLayerItem.TPJSON(), False, True)
                            self.inspector.deselectItems()
                            newItem = self.inspector.search(self.pdata['gid'], 'gid')
                            self.inspector.selectItem(newItem, False)

                            if self.pdata['type'] == 'Widget_Group' :
                                for c in self.pdata['children'] :
                                    i = self.inspector.search(c['gid'], 'gid')
                                    i.parent().removeRow(i.row())

                            return
                        elif self.main.command == "setUIInfo" :
                            self.inspector.preventChanges = True
                            item = self.inspector.search(self.pdata['gid'], 'gid')
                            item.setTPJSON(self.pdata)
                            self.unsavedChanges = True
                            self.inspector.preventChanges = False
                        else:
                            self.inspector.curData = self.pdata
                            if self.inspector.curItemGid == self.inspector.curData['gid'] :
                                if self.main.command is not "setUIInfo" :
                                    self.inspector.preventChanges = True
                                    self.inspector.propertyFill(self.inspector.curData)
                                    if self.ve_ready == False :
                                        self.unsavedChanges = True
                                    self.ve_ready = False
                            self.inspector.preventChanges = False

                    if sdata is not None and self.pdata is not None and self.main.command is not "getStInfo" and self.main.command is not "setUIInfo":
                        self.inspector.preventChanges = True
                        self.contentMoveBlock = True
                        self.inspector.clearTree()
                        self.inspector.inspectorModel.inspector_reply_finished(self.pdata, sdata)

                        self.inspector.screenChanged(self.inspector.ui.screenCombo.findText(self.inspector.currentScreenName))
                        self.contentMoveBlock = False

                        self.main.sendLuaCommand("refreshDone", "_VE_.refreshDone()")
                        try:
                            result = self.inspector.search(self.inspector.setGid, 'gid')
                            if result:
                                self.inspector.ui.inspector.selectionModel().clear()
                        except :
                            pass

                        self.inspector.preventChanges = False
                        try :
                            if self.main.menuCommand == "newProject" :
                                self.main.sendLuaCommand("openFile", "_VE_.openFile(\""+str(self.main.path+"\")"))
                                self.main.sendLuaCommand("setCurrentProject", "_VE_.setCurrentProject(\""+os.path.basename(str(self.main.path))+"  "+self.inspector.currentScreenName+"\")")
                                
                                self.main.menuCommand = ""

                        except:
                            pass

                        if self.main.lastObject :
                            selItem = self.inspector.search(self.main.lastObject, 'name')
                            if selItem :
                                gid = selItem.TPJSON()['gid']
                                self.inspector.ui.property.clear()
                                self.inspector.selectItem(selItem, "false")

                        if self.main.command == "openFile":
                            self.main.command = ""


                elif s is not None:
                    pass

    def app_finished(self, errorCode):
        if self.trickplay.state() == QProcess.NotRunning :
            print "[VE] Trickplay APP is finished"
            self.inspector.clearTree()
            self.main.stop()
            self.main.ui.actionEditor.setEnabled(False)

    def run(self):
        # Run on local trickplay
        print("[VE] Starting trickplay locally")
        if self.trickplay.state() == QProcess.Running:
            self.trickplay.close()

        env = self.trickplay.processEnvironment().systemEnvironment()

        for item in env.toStringList():
            if item[:3] == "TP_":
                n = re.search("=", item).end()
                env.remove(item[:n-1])

        env.insert("TP_first_app_exits", "false")
        env.insert("TP_LOG", "raw")
        env.insert("TP_config_file","")

        #  To merge stdout and stderr
        self.trickplay.setProcessChannelMode( QProcess.MergedChannels )

        self.trickplay.setProcessEnvironment(env)

        self.trickplay.start('trickplay', [self.path()])
        ret = self.trickplay.waitForStarted()
        if ret == False :
            if self.trickplay.error() == QProcess.FailedToStart :
                self.main.errorMsg("TrickPlay engine failed to launch: check TrickPlay SDK installation")
            elif self.trickplay.error() == QProcess.Timedout :
                self.main.errorMsg("TrickPlay engine launch timed out: check TrickPlay SDK installation")




