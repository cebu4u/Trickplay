# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'MainWindow.ui'
#
# Created: Mon Feb 27 09:48:06 2012
#      by: PyQt4 UI code generator 4.8.3
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    _fromUtf8 = lambda s: s

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        
        MainWindow.setObjectName(_fromUtf8("MainWindow"))
        MainWindow.setEnabled(True)
        MainWindow.resize(1020, 744)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Ignored, QtGui.QSizePolicy.Ignored)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(MainWindow.sizePolicy().hasHeightForWidth())
        MainWindow.setSizePolicy(sizePolicy)
        MainWindow.setMinimumSize(QtCore.QSize(200, 200))
        MainWindow.setCursor(QtCore.Qt.ArrowCursor)
        MainWindow.setLayoutDirection(QtCore.Qt.LeftToRight)
        self.centralwidget = QtGui.QWidget(MainWindow)
        self.centralwidget.setObjectName(_fromUtf8("centralwidget"))
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtGui.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 1020, 27))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.menubar.setFont(font)
        self.menubar.setObjectName(_fromUtf8("menubar"))
        self.menuFile = QtGui.QMenu(self.menubar)
        self.menuFile.setObjectName(_fromUtf8("menuFile"))
        self.menuView = QtGui.QMenu(self.menubar)
        self.menuView.setObjectName(_fromUtf8("menuView"))
        self.menuEdit = QtGui.QMenu(self.menubar)
        self.menuEdit.setObjectName(_fromUtf8("menuEdit"))
        self.menuRun = QtGui.QMenu(self.menubar)
        self.menuRun.setObjectName(_fromUtf8("menuRun"))
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtGui.QStatusBar(MainWindow)
        self.statusbar.setObjectName(_fromUtf8("statusbar"))
        MainWindow.setStatusBar(self.statusbar)
        self.FileSystemDock = QtGui.QDockWidget(MainWindow)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Preferred, QtGui.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.FileSystemDock.sizePolicy().hasHeightForWidth())
        self.FileSystemDock.setSizePolicy(sizePolicy)
        self.FileSystemDock.setMinimumSize(QtCore.QSize(215, 100))
        self.FileSystemDock.setFloating(False)
        self.FileSystemDock.setFeatures(QtGui.QDockWidget.DockWidgetClosable)
        #self.FileSystemDock.setWindowTitle(_fromUtf8(""))
        fstitleWidget = QtGui.QWidget()
        self.FileSystemDock.setTitleBarWidget(fstitleWidget)
        
        self.FileSystemDock.setObjectName(_fromUtf8("FileSystemDock"))
        self.FileSystemContainer = QtGui.QWidget()
        self.FileSystemContainer.setObjectName(_fromUtf8("FileSystemContainer"))
        self.gridLayout_4 = QtGui.QGridLayout(self.FileSystemContainer)
        self.gridLayout_4.setMargin(1)
        self.gridLayout_4.setSpacing(1)
        self.gridLayout_4.setObjectName(_fromUtf8("gridLayout_4"))
        self.FileSystemLayout = QtGui.QGridLayout()
        self.FileSystemLayout.setMargin(0)
        self.FileSystemLayout.setSpacing(0)
        self.FileSystemLayout.setObjectName(_fromUtf8("FileSystemLayout"))
        self.gridLayout_4.addLayout(self.FileSystemLayout, 0, 0, 1, 1)
        self.FileSystemDock.setWidget(self.FileSystemContainer)
        MainWindow.addDockWidget(QtCore.Qt.DockWidgetArea(1), self.FileSystemDock)
        self.DebugDock = QtGui.QDockWidget(MainWindow)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Preferred, QtGui.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.DebugDock.sizePolicy().hasHeightForWidth())
        self.DebugDock.setSizePolicy(sizePolicy)
        self.DebugDock.setMinimumSize(QtCore.QSize(215, 100))
        font = QtGui.QFont()
        font.setPointSize(10)
        self.DebugDock.setFont(font)
        self.DebugDock.setFloating(False)
        self.DebugDock.setFeatures(QtGui.QDockWidget.DockWidgetClosable)
        self.DebugDock.setWindowTitle(_fromUtf8(""))
        debugtitleWidget = QtGui.QWidget()
        self.DebugDock.setTitleBarWidget(debugtitleWidget)
        
        self.DebugDock.setObjectName(_fromUtf8("DebugDock"))
        self.DebugContainer = QtGui.QWidget()
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Preferred, QtGui.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.DebugContainer.sizePolicy().hasHeightForWidth())
        self.DebugContainer.setSizePolicy(sizePolicy)
        self.DebugContainer.setMinimumSize(QtCore.QSize(0, 0))
        font = QtGui.QFont()
        font.setPointSize(10)
        self.DebugContainer.setFont(font)
        self.DebugContainer.setObjectName(_fromUtf8("DebugContainer"))
        self.verticalLayout_2 = QtGui.QVBoxLayout(self.DebugContainer)
        self.verticalLayout_2.setSpacing(1)
        self.verticalLayout_2.setMargin(1)
        self.verticalLayout_2.setObjectName(_fromUtf8("verticalLayout_2"))
        self.DebugLayout = QtGui.QGridLayout()
        self.DebugLayout.setSpacing(0)
        self.DebugLayout.setObjectName(_fromUtf8("DebugLayout"))
        self.verticalLayout_2.addLayout(self.DebugLayout)
        self.DebugDock.setWidget(self.DebugContainer)
        MainWindow.addDockWidget(QtCore.Qt.DockWidgetArea(1), self.DebugDock)
        self.InspectorDock = QtGui.QDockWidget(MainWindow)
        self.InspectorDock.setEnabled(True)
        self.InspectorDock.setMinimumSize(QtCore.QSize(300, 45))
        self.InspectorDock.setContextMenuPolicy(QtCore.Qt.NoContextMenu)
        self.InspectorDock.setFeatures(QtGui.QDockWidget.DockWidgetClosable)
        self.InspectorDock.setWindowTitle(_fromUtf8(""))
        inspectortitleWidget = QtGui.QWidget()
        self.InspectorDock.setTitleBarWidget(inspectortitleWidget)

        self.InspectorDock.setObjectName(_fromUtf8("InspectorDock"))
        self.InspectorContainer = QtGui.QWidget()
        self.InspectorContainer.setObjectName(_fromUtf8("InspectorContainer"))
        self.gridLayout_7 = QtGui.QGridLayout(self.InspectorContainer)
        self.gridLayout_7.setMargin(1)
        self.gridLayout_7.setSpacing(1)
        self.gridLayout_7.setObjectName(_fromUtf8("gridLayout_7"))
        self.InspectorLayout = QtGui.QGridLayout()
        self.InspectorLayout.setSpacing(0)
        self.InspectorLayout.setObjectName(_fromUtf8("InspectorLayout"))
        self.gridLayout_7.addLayout(self.InspectorLayout, 0, 0, 1, 1)
        self.InspectorDock.setWidget(self.InspectorContainer)
        MainWindow.addDockWidget(QtCore.Qt.DockWidgetArea(2), self.InspectorDock)
        self.BacktraceDock = QtGui.QDockWidget(MainWindow)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Preferred, QtGui.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.BacktraceDock.sizePolicy().hasHeightForWidth())
        self.BacktraceDock.setSizePolicy(sizePolicy)
        self.BacktraceDock.setMinimumSize(QtCore.QSize(210, 100))
        self.BacktraceDock.setFloating(False)
        self.BacktraceDock.setFeatures(QtGui.QDockWidget.DockWidgetClosable)
        self.BacktraceDock.setWindowTitle(_fromUtf8(""))
        bttitleWidget = QtGui.QWidget()
        self.BacktraceDock.setTitleBarWidget(bttitleWidget)

        self.BacktraceDock.setObjectName(_fromUtf8("BacktraceDock"))
        self.BackTraceContainer = QtGui.QWidget()
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Preferred, QtGui.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.BackTraceContainer.sizePolicy().hasHeightForWidth())
        self.BackTraceContainer.setSizePolicy(sizePolicy)
        self.BackTraceContainer.setMinimumSize(QtCore.QSize(0, 0))
        self.BackTraceContainer.setObjectName(_fromUtf8("BackTraceContainer"))
        self.verticalLayout_3 = QtGui.QVBoxLayout(self.BackTraceContainer)
        self.verticalLayout_3.setSpacing(1)
        self.verticalLayout_3.setMargin(1)
        self.verticalLayout_3.setObjectName(_fromUtf8("verticalLayout_3"))
        self.BacktraceLayout = QtGui.QGridLayout()
        self.BacktraceLayout.setSpacing(0)
        self.BacktraceLayout.setObjectName(_fromUtf8("BacktraceLayout"))
        self.verticalLayout_3.addLayout(self.BacktraceLayout)
        self.BacktraceDock.setWidget(self.BackTraceContainer)
        MainWindow.addDockWidget(QtCore.Qt.DockWidgetArea(8), self.BacktraceDock)
        self.ConsoleDock = QtGui.QDockWidget(MainWindow)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Preferred, QtGui.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.ConsoleDock.sizePolicy().hasHeightForWidth())
        self.ConsoleDock.setSizePolicy(sizePolicy)
        self.ConsoleDock.setMinimumSize(QtCore.QSize(790, 57))
        self.ConsoleDock.setFloating(False)
        self.ConsoleDock.setFeatures(QtGui.QDockWidget.DockWidgetClosable)
        self.ConsoleDock.setWindowTitle(_fromUtf8(""))
        cstitleWidget = QtGui.QWidget()
        self.ConsoleDock.setTitleBarWidget(cstitleWidget)

        self.ConsoleDock.setObjectName(_fromUtf8("ConsoleDock"))
        self.ConsoleContainer = QtGui.QWidget()
        self.ConsoleContainer.setObjectName(_fromUtf8("ConsoleContainer"))
        self.gridLayout_5 = QtGui.QGridLayout(self.ConsoleContainer)
        self.gridLayout_5.setMargin(1)
        self.gridLayout_5.setSpacing(1)
        self.gridLayout_5.setObjectName(_fromUtf8("gridLayout_5"))
        self.ConsoleLayout = QtGui.QGridLayout()
        self.ConsoleLayout.setSpacing(0)
        self.ConsoleLayout.setObjectName(_fromUtf8("ConsoleLayout"))
        self.gridLayout_5.addLayout(self.ConsoleLayout, 1, 0, 1, 1)
        self.interactive = QtGui.QLineEdit(self.ConsoleContainer)

        monofont = QtGui.QFont()
        monofont.setStyleHint(monofont.Monospace)
        monofont.setFamily('Inconsolata')
        monofont.setPointSize(12)

        self.interactive.setFont(monofont)
        self.interactive.setText(_fromUtf8(""))
        self.interactive.setObjectName(_fromUtf8("interactive"))
        self.gridLayout_5.addWidget(self.interactive, 2, 0, 1, 1)
        self.ConsoleDock.setWidget(self.ConsoleContainer)
        MainWindow.addDockWidget(QtCore.Qt.DockWidgetArea(8), self.ConsoleDock)
        self.actionExit = QtGui.QAction(MainWindow)
        self.actionExit.setObjectName(_fromUtf8("actionExit"))
        self.action_Exit = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.action_Exit.setFont(font)
        self.action_Exit.setMenuRole(QtGui.QAction.QuitRole)
        self.action_Exit.setObjectName(_fromUtf8("action_Exit"))
        self.action_Save = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.action_Save.setFont(font)
        self.action_Save.setObjectName(_fromUtf8("action_Save"))
        self.action_New = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.action_New.setFont(font)
        self.action_New.setShortcutContext(QtCore.Qt.WindowShortcut)
        self.action_New.setObjectName(_fromUtf8("action_New"))
        self.action_Cut = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.action_Cut.setFont(font)
        self.action_Cut.setObjectName(_fromUtf8("action_Cut"))
        self.action_Copy = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.action_Copy.setFont(font)
        self.action_Copy.setObjectName(_fromUtf8("action_Copy"))
        self.action_Paste = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.action_Paste.setFont(font)
        self.action_Paste.setObjectName(_fromUtf8("action_Paste"))
        self.action_Delete = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.action_Delete.setFont(font)
        self.action_Delete.setObjectName(_fromUtf8("action_Delete"))
        self.actionSelect_All = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.actionSelect_All.setFont(font)
        self.actionSelect_All.setObjectName(_fromUtf8("actionSelect_All"))
        self.action_Close = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.action_Close.setFont(font)
        self.action_Close.setObjectName(_fromUtf8("action_Close"))
        self.action_Save_As = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.action_Save_As.setFont(font)
        self.action_Save_As.setObjectName(_fromUtf8("action_Save_As"))
        self.actionUndo = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.actionUndo.setFont(font)
        self.actionUndo.setObjectName(_fromUtf8("actionUndo"))
        self.actionRedo = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.actionRedo.setFont(font)
        self.actionRedo.setObjectName(_fromUtf8("actionRedo"))
        self.actionDebug = QtGui.QAction(MainWindow)
        self.actionDebug.setObjectName(_fromUtf8("actionDebug"))
        self.actionRun = QtGui.QAction(MainWindow)
        self.actionRun.setObjectName(_fromUtf8("actionRun"))
        self.actionStep_into = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.actionStep_into.setFont(font)
        self.actionStep_into.setObjectName(_fromUtf8("actionStep_into"))
        self.actionStep_over = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.actionStep_over.setFont(font)
        self.actionStep_over.setObjectName(_fromUtf8("actionStep_over"))
        self.actionDebug_View = QtGui.QAction(MainWindow)
        self.actionDebug_View.setObjectName(_fromUtf8("actionDebug_View"))
        self.actionRun_View = QtGui.QAction(MainWindow)
        self.actionRun_View.setObjectName(_fromUtf8("actionRun_View"))
        self.actionSave_All = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.actionSave_All.setFont(font)
        self.actionSave_All.setObjectName(_fromUtf8("actionSave_All"))
        self.actionSearch = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.actionSearch.setFont(font)
        self.actionSearch.setObjectName(_fromUtf8("actionSearch"))
        self.actionSearch_Replace = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.actionSearch_Replace.setFont(font)
        self.actionSearch_Replace.setObjectName(_fromUtf8("actionSearch_Replace"))
        self.actionGo_to_line = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.actionGo_to_line.setFont(font)
        self.actionGo_to_line.setObjectName(_fromUtf8("actionGo_to_line"))
        self.actionSearch_in_Files = QtGui.QAction(MainWindow)
        self.actionSearch_in_Files.setObjectName(_fromUtf8("actionSearch_in_Files"))
        self.actionBeutify_Selection = QtGui.QAction(MainWindow)
        self.actionBeutify_Selection.setObjectName(_fromUtf8("actionBeutify_Selection"))
        self.actionStrip_Whitespace = QtGui.QAction(MainWindow)
        self.actionStrip_Whitespace.setObjectName(_fromUtf8("actionStrip_Whitespace"))
        self.actionStep_out = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.actionStep_out.setFont(font)
        self.actionStep_out.setObjectName(_fromUtf8("actionStep_out"))
        self.actionStop = QtGui.QAction(MainWindow)
        self.actionStop.setObjectName(_fromUtf8("actionStop"))
        self.actionPause = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.actionPause.setFont(font)
        self.actionPause.setObjectName(_fromUtf8("actionPause"))
        self.actionContinue = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.actionContinue.setFont(font)
        self.actionContinue.setObjectName(_fromUtf8("actionContinue"))
        self.actionNew_File = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.actionNew_File.setFont(font)
        self.actionNew_File.setObjectName(_fromUtf8("actionNew_File"))
        self.actionNew_Folder = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.actionNew_Folder.setFont(font)
        self.actionNew_Folder.setObjectName(_fromUtf8("actionNew_Folder"))
        self.actionOpen_App = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(11)
        self.actionOpen_App.setFont(font)
        self.actionOpen_App.setObjectName(_fromUtf8("actionOpen_App"))
        self.actionNew_App = QtGui.QAction(MainWindow)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.actionNew_App.setFont(font)
        self.actionNew_App.setObjectName(_fromUtf8("actionNew_App"))
        self.action_Run = QtGui.QAction(MainWindow)
        self.action_Run.setObjectName(_fromUtf8("action_Run"))
        self.action_Debug = QtGui.QAction(MainWindow)
        self.action_Debug.setObjectName(_fromUtf8("action_Debug"))
        self.action_Stop = QtGui.QAction(MainWindow)
        self.action_Stop.setObjectName(_fromUtf8("action_Stop"))

        self.menuFile.addAction(self.action_New)
        self.menuFile.addAction(self.actionOpen_App)
        self.menuFile.addSeparator()
        self.menuFile.addAction(self.actionNew_File)
        self.menuFile.addAction(self.action_Save)
        self.menuFile.addAction(self.action_Save_As)
        self.menuFile.addAction(self.actionSave_All)
        self.menuFile.addAction(self.action_Close)
        self.menuFile.addAction(self.action_Exit)
        self.menuEdit.addAction(self.actionUndo)
        self.menuEdit.addAction(self.actionRedo)
        self.menuEdit.addSeparator()
        self.menuEdit.addAction(self.action_Cut)
        self.menuEdit.addAction(self.action_Copy)
        self.menuEdit.addAction(self.action_Paste)
        self.menuEdit.addAction(self.action_Delete)
        self.menuEdit.addAction(self.actionSelect_All)
        self.menuEdit.addSeparator()
        self.menuEdit.addAction(self.actionSearch_Replace)
        self.menuEdit.addAction(self.actionGo_to_line)
        self.menuRun.addAction(self.action_Run)
        self.menuRun.addAction(self.action_Debug)
        self.menuRun.addAction(self.action_Stop)
        self.menuRun.addAction(self.actionContinue)
        self.menuRun.addAction(self.actionPause)
        self.menuRun.addAction(self.actionStep_into)
        self.menuRun.addAction(self.actionStep_over)
        self.menuRun.addAction(self.actionStep_out)
        self.menubar.addAction(self.menuFile.menuAction())
        self.menubar.addAction(self.menuEdit.menuAction())
        self.menubar.addAction(self.menuRun.menuAction())
        self.menubar.addAction(self.menuView.menuAction())

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QtGui.QApplication.translate("MainWindow", "Trickplay IDE", None, QtGui.QApplication.UnicodeUTF8))
        self.menuFile.setTitle(QtGui.QApplication.translate("MainWindow", "File", None, QtGui.QApplication.UnicodeUTF8))
        self.menuView.setTitle(QtGui.QApplication.translate("MainWindow", "Windows", None, QtGui.QApplication.UnicodeUTF8))
        self.menuEdit.setTitle(QtGui.QApplication.translate("MainWindow", "Edit", None, QtGui.QApplication.UnicodeUTF8))
        self.menuRun.setTitle(QtGui.QApplication.translate("MainWindow", "Debug", None, QtGui.QApplication.UnicodeUTF8))
        self.actionExit.setText(QtGui.QApplication.translate("MainWindow", "Exit", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Exit.setText(QtGui.QApplication.translate("MainWindow", "Exit", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Exit.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+Q", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Save.setText(QtGui.QApplication.translate("MainWindow", "Save file", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Save.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+S", None, QtGui.QApplication.UnicodeUTF8))
        self.action_New.setText(QtGui.QApplication.translate("MainWindow", "Create new  app...", None, QtGui.QApplication.UnicodeUTF8))
        self.action_New.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+Shift+N", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Cut.setText(QtGui.QApplication.translate("MainWindow", "Cut", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Cut.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+X", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Copy.setText(QtGui.QApplication.translate("MainWindow", "Copy", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Copy.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+C", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Paste.setText(QtGui.QApplication.translate("MainWindow", "Paste", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Paste.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+V", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Delete.setText(QtGui.QApplication.translate("MainWindow", "Delete", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Delete.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+D", None, QtGui.QApplication.UnicodeUTF8))
        self.actionSelect_All.setText(QtGui.QApplication.translate("MainWindow", "Select all", None, QtGui.QApplication.UnicodeUTF8))
        self.actionSelect_All.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+A", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Close.setText(QtGui.QApplication.translate("MainWindow", "Close file", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Close.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+W", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Save_As.setText(QtGui.QApplication.translate("MainWindow", "Save file as...", None, QtGui.QApplication.UnicodeUTF8))
        self.actionUndo.setText(QtGui.QApplication.translate("MainWindow", "Undo", None, QtGui.QApplication.UnicodeUTF8))
        self.actionUndo.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+Z", None, QtGui.QApplication.UnicodeUTF8))
        self.actionRedo.setText(QtGui.QApplication.translate("MainWindow", "Redo", None, QtGui.QApplication.UnicodeUTF8))
        self.actionRedo.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+R", None, QtGui.QApplication.UnicodeUTF8))
        self.actionDebug.setText(QtGui.QApplication.translate("MainWindow", "Debug", None, QtGui.QApplication.UnicodeUTF8))
        self.actionRun.setText(QtGui.QApplication.translate("MainWindow", "Run", None, QtGui.QApplication.UnicodeUTF8))
        self.actionStep_into.setText(QtGui.QApplication.translate("MainWindow", "Step Into", None, QtGui.QApplication.UnicodeUTF8))
        self.actionStep_into.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+I", None, QtGui.QApplication.UnicodeUTF8))
        self.actionStep_over.setText(QtGui.QApplication.translate("MainWindow", "Step over", None, QtGui.QApplication.UnicodeUTF8))
        self.actionStep_over.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+K", None, QtGui.QApplication.UnicodeUTF8))
        self.actionDebug_View.setText(QtGui.QApplication.translate("MainWindow", "Debug View", None, QtGui.QApplication.UnicodeUTF8))
        self.actionRun_View.setText(QtGui.QApplication.translate("MainWindow", "Run View", None, QtGui.QApplication.UnicodeUTF8))
        self.actionSave_All.setText(QtGui.QApplication.translate("MainWindow", "Save all files", None, QtGui.QApplication.UnicodeUTF8))
        self.actionSearch.setText(QtGui.QApplication.translate("MainWindow", "Search...", None, QtGui.QApplication.UnicodeUTF8))
        self.actionSearch.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+F", None, QtGui.QApplication.UnicodeUTF8))
        self.actionSearch_Replace.setText(QtGui.QApplication.translate("MainWindow", "Find/Replace...", None, QtGui.QApplication.UnicodeUTF8))
        self.actionSearch_Replace.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+F", None, QtGui.QApplication.UnicodeUTF8))
        self.actionGo_to_line.setText(QtGui.QApplication.translate("MainWindow", "Go to line...", None, QtGui.QApplication.UnicodeUTF8))
        self.actionGo_to_line.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+J", None, QtGui.QApplication.UnicodeUTF8))
        self.actionSearch_in_Files.setText(QtGui.QApplication.translate("MainWindow", "Search in Files...", None, QtGui.QApplication.UnicodeUTF8))
        self.actionBeutify_Selection.setText(QtGui.QApplication.translate("MainWindow", "Beutify Selection", None, QtGui.QApplication.UnicodeUTF8))
        self.actionStrip_Whitespace.setText(QtGui.QApplication.translate("MainWindow", "Strip Whitespace", None, QtGui.QApplication.UnicodeUTF8))
        self.actionStep_out.setText(QtGui.QApplication.translate("MainWindow", "Step out", None, QtGui.QApplication.UnicodeUTF8))
        self.actionStep_out.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+M", None, QtGui.QApplication.UnicodeUTF8))
        self.actionStop.setText(QtGui.QApplication.translate("MainWindow", "Stop", None, QtGui.QApplication.UnicodeUTF8))
        self.actionPause.setText(QtGui.QApplication.translate("MainWindow", "Pause", None, QtGui.QApplication.UnicodeUTF8))
        self.actionPause.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+P", None, QtGui.QApplication.UnicodeUTF8))
        self.actionContinue.setText(QtGui.QApplication.translate("MainWindow", "Continue", None, QtGui.QApplication.UnicodeUTF8))
        self.actionContinue.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+B", None, QtGui.QApplication.UnicodeUTF8))
        self.actionNew_File.setText(QtGui.QApplication.translate("MainWindow", "Create new file...", None, QtGui.QApplication.UnicodeUTF8))
        self.actionNew_File.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+N", None, QtGui.QApplication.UnicodeUTF8))
        self.actionNew_Folder.setText(QtGui.QApplication.translate("MainWindow", "New Folder", None, QtGui.QApplication.UnicodeUTF8))
        self.actionOpen_App.setText(QtGui.QApplication.translate("MainWindow", "Open existing app...", None, QtGui.QApplication.UnicodeUTF8))
        self.actionOpen_App.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+O", None, QtGui.QApplication.UnicodeUTF8))
        self.actionNew_App.setText(QtGui.QApplication.translate("MainWindow", "New App", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Run.setText(QtGui.QApplication.translate("MainWindow", "Run", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Run.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+F11", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Debug.setText(QtGui.QApplication.translate("MainWindow", "Debug", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Debug.setShortcut(QtGui.QApplication.translate("MainWindow", "F11", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Stop.setText(QtGui.QApplication.translate("MainWindow", "Stop", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Stop.setShortcut(QtGui.QApplication.translate("MainWindow", "Esc", None, QtGui.QApplication.UnicodeUTF8))

