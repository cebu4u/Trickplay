import os
import sys
import signal

from PyQt4.QtGui import *
from PyQt4.QtCore import *

from UI.MainWindow import Ui_MainWindow

from connection import CON
from wizard import Wizard

from Inspector.TrickplayInspector import TrickplayInspector
from DeviceManager.TrickplayDeviceManager import TrickplayDeviceManager
from Editor.EditorManager import EditorManager
from FileSystem.FileSystem import FileSystem
from Console.TrickplayConsole import TrickplayConsole

class MainWindow(QMainWindow):
    
    def __init__(self, app, parent = None):
        
        QWidget.__init__(self, parent)
        
        # Restore size/position of window
        settings = QSettings()
        self.restoreGeometry(settings.value("mainWindowGeometry").toByteArray());
        
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)
        
        # Create FileSystem
        self.ui.FileSystemDock.toggleViewAction().setText("&File System")
        self.ui.menuView.addAction(self.ui.FileSystemDock.toggleViewAction())
        #self.ui.FileSystemDock.toggleViewAction().triggered.connect(self.fs)
        self._fileSystem = FileSystem()
        self.ui.FileSystemLayout.addWidget(self._fileSystem)
        
        # Create Editor
        self._editorManager = EditorManager(self._fileSystem, self.ui.centralwidget)
        
        # Create Inspector
        self.ui.InspectorDock.toggleViewAction().setText("&Inspector")
        self.ui.menuView.addAction(self.ui.InspectorDock.toggleViewAction())
        #self.ui.InspectorDock.toggleViewAction().triggered.connect(self.isptr)
        self._inspector = TrickplayInspector()
        self.ui.InspectorLayout.addWidget(self._inspector)
        
        # Create DeviceManager
        self.ui.DeviceManagerDock.toggleViewAction().setText("&Device Manager")
        self.ui.menuView.addAction(self.ui.DeviceManagerDock.toggleViewAction())
        #self.ui.DeviceManagerDock.toggleViewAction().triggered.connect(self.dm)
        self._deviceManager = TrickplayDeviceManager(self._inspector)
        self.ui.DeviceManagerLayout.addWidget(self._deviceManager)
        
        # Create Console
        self.ui.ConsoleDock.toggleViewAction().setText("&Console")
        self.ui.menuView.addAction(self.ui.ConsoleDock.toggleViewAction())
        #self.ui.DeviceManagerDock.toggleViewAction().triggered.connect(self.dm)
        self._console = TrickplayConsole()
        self.ui.ConsoleLayout.addWidget(self._console)
	
		## make them aware of one another
        # Toolbar
        QObject.connect(self.ui.action_Exit, SIGNAL("triggered()"),  self.exit)
        QObject.connect(self.ui.action_Save, SIGNAL('triggered()'),  self.editorManager.save)
        
        # Restore sizes/positions of docks
        #self.restoreState(settings.value("mainWindowState").toByteArray());
        
        self.path = None
        
        QObject.connect(app, SIGNAL('aboutToQuit()'), self.cleanUp)
        
        self.app = app
        
    @property
    def fileSystem(self):
        return self._fileSystem
    
    @property
    def deviceManager(self):
        return self._deviceManager
    
    @property
    def editorManager(self):
        return self._editorManager
    
    @property
    def inspector(self):
        return self._inspector

    def cleanUp(self):
        """
        End running Trickplay process
        
        TODO: Somehow stop Trickplay Avahi service...
        """
        
        try:
            print('Trickplay state', self.deviceManager.trickplay.state())
            #if self.trickplay.state() == QProcess.Running:
            self.deviceManager.trickplay.close()
            #    print('terminated trickplay')
        except AttributeError, e:
            pass
        
        #print('quitting')
        
    
    def start(self, path, openList = None):
        """
        Initialize widgets on the main window with a given app path
        """
        
        self.path = path
        
        self.fileSystem.start(self.editorManager, path)
        
        self.deviceManager.setPath(path)
        
        if openList:
            for file in openList:
                self.editorManager.newEditor(file)

    def closeEvent(self, event):
        """
        Save window and dock geometry on close
        """
        
        settings = QSettings()
        settings.setValue("mainWindowGeometry", self.saveGeometry());
        settings.setValue("mainWindowState", self.saveState());
        
    def exit(self):
        """
        Close in a clean way... but still Trickplay closes too soon and the
        Avahi service stays alive
        """
        
        self.close()

    def dm(self):
		print "dm"

    def fs(self):
		print "fs"

    def isptr(self):
		print "inptr"
        
        
