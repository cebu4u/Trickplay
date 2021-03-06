from PyQt4.QtGui import *
from PyQt4.QtCore import *

from FileSystemModel import FileSystemModel

from UI.FileSystem import Ui_FileSystem

class FileSystem(QWidget):
    
    def __init__(self, pref=None, parent = None):
        
        QWidget.__init__(self, parent)
        
        self.ui = Ui_FileSystem()
        self.ui.setupUi(self)
        self.preference = pref 

        self.ui.view.setFont(self.preference.fsFont)
        
        self.editorManager = None
        
        
    def start(self, editorManager, path):
        """
        Start the FileSystem with the given app path and editor
        """
        
        self.model = FileSystemModel(self.ui.view, path, editorManager, self)
        
        self.editorManager = editorManager
        
        QObject.connect(self.ui.view,
                        SIGNAL('doubleClicked( QModelIndex )'),
                        self.editorManager.openFromFileSystem)
