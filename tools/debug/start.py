#!/usr/bin/env python

# Allow keyboard interrupt with ^C
import sys
import signal

from wizard import Wizard
from main import MainWindow

from PyQt4.QtGui import QApplication
from PyQt4.QtCore import QCoreApplication, QSettings, QT_VERSION_STR

signal.signal(signal.SIGINT, signal.SIG_DFL)

def main(argv):
    
    path = None
    print("QT VERSION %s" % QT_VERSION_STR )
    
    try:
        path = argv[1]
    except IndexError:
        pass
    
    try:
    
        app = QApplication(argv)
            
        QCoreApplication.setOrganizationDomain('www.trickplay.com');
        QCoreApplication.setOrganizationName('Trickplay');
        QCoreApplication.setApplicationName('Trickplay Debugger');
        QCoreApplication.setApplicationVersion('0.0.1');
            
        main = MainWindow(app)
        main.show()
        wizard = Wizard()
        
        path = wizard.start(path)
        if path:
            settings = QSettings()
            settings.setValue('path', path)
            
            app.setActiveWindow(main)
            main.start(path, wizard.filesToOpen())
            main.show()
        
        sys.exit(app.exec_())
    
    # TODO, better way of doing this for 'clean' exit...
    except KeyboardInterrupt:
		exit("Exited")


if __name__ == '__main__':
    main(sys.argv)
