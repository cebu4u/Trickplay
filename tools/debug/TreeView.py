# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'TreeView.ui'
#
# Created: Tue Jul 19 14:58:19 2011
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
        MainWindow.resize(464, 832)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Ignored, QtGui.QSizePolicy.Ignored)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(MainWindow.sizePolicy().hasHeightForWidth())
        MainWindow.setSizePolicy(sizePolicy)
        MainWindow.setCursor(QtCore.Qt.ArrowCursor)
        self.centralwidget = QtGui.QWidget(MainWindow)
        self.centralwidget.setObjectName(_fromUtf8("centralwidget"))
        self.splitter = QtGui.QSplitter(self.centralwidget)
        self.splitter.setGeometry(QtCore.QRect(0, 0, 0, 0))
        self.splitter.setOrientation(QtCore.Qt.Vertical)
        self.splitter.setObjectName(_fromUtf8("splitter"))
        self.layoutWidget = QtGui.QWidget(self.centralwidget)
        self.layoutWidget.setGeometry(QtCore.QRect(0, 0, 2, 2))
        self.layoutWidget.setObjectName(_fromUtf8("layoutWidget"))
        self.gridLayout = QtGui.QGridLayout(self.layoutWidget)
        self.gridLayout.setMargin(0)
        self.gridLayout.setObjectName(_fromUtf8("gridLayout"))
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtGui.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 464, 25))
        self.menubar.setObjectName(_fromUtf8("menubar"))
        self.menuFile = QtGui.QMenu(self.menubar)
        self.menuFile.setObjectName(_fromUtf8("menuFile"))
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtGui.QStatusBar(MainWindow)
        self.statusbar.setObjectName(_fromUtf8("statusbar"))
        MainWindow.setStatusBar(self.statusbar)
        self.dockWidget_2 = QtGui.QDockWidget(MainWindow)
        self.dockWidget_2.setEnabled(True)
        self.dockWidget_2.setContextMenuPolicy(QtCore.Qt.NoContextMenu)
        self.dockWidget_2.setObjectName(_fromUtf8("dockWidget_2"))
        self.dockWidgetContents_2 = QtGui.QWidget()
        self.dockWidgetContents_2.setObjectName(_fromUtf8("dockWidgetContents_2"))
        self.gridLayout_2 = QtGui.QGridLayout(self.dockWidgetContents_2)
        self.gridLayout_2.setObjectName(_fromUtf8("gridLayout_2"))
        self.horizontalLayout = QtGui.QHBoxLayout()
        self.horizontalLayout.setObjectName(_fromUtf8("horizontalLayout"))
        self.button_Refresh = QtGui.QPushButton(self.dockWidgetContents_2)
        self.button_Refresh.setObjectName(_fromUtf8("button_Refresh"))
        self.horizontalLayout.addWidget(self.button_Refresh)
        self.button_ExpandAll = QtGui.QPushButton(self.dockWidgetContents_2)
        self.button_ExpandAll.setObjectName(_fromUtf8("button_ExpandAll"))
        self.horizontalLayout.addWidget(self.button_ExpandAll)
        self.button_CollapseAll = QtGui.QPushButton(self.dockWidgetContents_2)
        self.button_CollapseAll.setObjectName(_fromUtf8("button_CollapseAll"))
        self.horizontalLayout.addWidget(self.button_CollapseAll)
        self.gridLayout_2.addLayout(self.horizontalLayout, 2, 0, 1, 1)
        self.inspector = QtGui.QTreeView(self.dockWidgetContents_2)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.inspector.sizePolicy().hasHeightForWidth())
        self.inspector.setSizePolicy(sizePolicy)
        self.inspector.setMinimumSize(QtCore.QSize(450, 0))
        palette = QtGui.QPalette()
        brush = QtGui.QBrush(QtGui.QColor(75, 105, 131, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Highlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(75, 105, 131, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Highlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(131, 131, 131))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Highlight, brush)
        self.inspector.setPalette(palette)
        self.inspector.setAutoFillBackground(False)
        self.inspector.setStyleSheet(_fromUtf8("/*QTreeView::branch {\n"
"    selection-background-color: transparent;\n"
"}\n"
"\n"
"selection-background-color: transparent;*/"))
        self.inspector.setDragDropMode(QtGui.QAbstractItemView.NoDragDrop)
        self.inspector.setAlternatingRowColors(True)
        self.inspector.setIndentation(20)
        self.inspector.setRootIsDecorated(True)
        self.inspector.setUniformRowHeights(True)
        self.inspector.setAnimated(False)
        self.inspector.setAllColumnsShowFocus(True)
        self.inspector.setObjectName(_fromUtf8("inspector"))
        self.inspector.header().setCascadingSectionResizes(True)
        self.inspector.header().setDefaultSectionSize(200)
        self.inspector.header().setHighlightSections(True)
        self.inspector.header().setMinimumSectionSize(30)
        self.inspector.header().setStretchLastSection(True)
        self.gridLayout_2.addWidget(self.inspector, 3, 0, 1, 1)
        self.horizontalLayout_5 = QtGui.QHBoxLayout()
        self.horizontalLayout_5.setObjectName(_fromUtf8("horizontalLayout_5"))
        self.button_Search = QtGui.QPushButton(self.dockWidgetContents_2)
        self.button_Search.setObjectName(_fromUtf8("button_Search"))
        self.horizontalLayout_5.addWidget(self.button_Search)
        self.lineEdit = QtGui.QLineEdit(self.dockWidgetContents_2)
        self.lineEdit.setText(_fromUtf8(""))
        self.lineEdit.setObjectName(_fromUtf8("lineEdit"))
        self.horizontalLayout_5.addWidget(self.lineEdit)
        self.gridLayout_2.addLayout(self.horizontalLayout_5, 0, 0, 1, 1)
        self.dockWidget_2.setWidget(self.dockWidgetContents_2)
        MainWindow.addDockWidget(QtCore.Qt.DockWidgetArea(1), self.dockWidget_2)
        self.dockWidget = QtGui.QDockWidget(MainWindow)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.dockWidget.sizePolicy().hasHeightForWidth())
        self.dockWidget.setSizePolicy(sizePolicy)
        self.dockWidget.setObjectName(_fromUtf8("dockWidget"))
        self.dockWidgetContents = QtGui.QWidget()
        self.dockWidgetContents.setObjectName(_fromUtf8("dockWidgetContents"))
        self.gridLayout_3 = QtGui.QGridLayout(self.dockWidgetContents)
        self.gridLayout_3.setObjectName(_fromUtf8("gridLayout_3"))
        self.property = QtGui.QTreeView(self.dockWidgetContents)
        self.property.setMinimumSize(QtCore.QSize(450, 0))
        self.property.setAlternatingRowColors(True)
        self.property.setObjectName(_fromUtf8("property"))
        self.property.header().setDefaultSectionSize(200)
        self.property.header().setMinimumSectionSize(30)
        self.gridLayout_3.addWidget(self.property, 0, 0, 1, 1)
        self.dockWidget.setWidget(self.dockWidgetContents)
        MainWindow.addDockWidget(QtCore.Qt.DockWidgetArea(1), self.dockWidget)
        self.actionExit = QtGui.QAction(MainWindow)
        self.actionExit.setObjectName(_fromUtf8("actionExit"))
        self.action_Exit = QtGui.QAction(MainWindow)
        self.action_Exit.setMenuRole(QtGui.QAction.QuitRole)
        self.action_Exit.setObjectName(_fromUtf8("action_Exit"))
        self.menuFile.addAction(self.action_Exit)
        self.menubar.addAction(self.menuFile.menuAction())

        self.retranslateUi(MainWindow)
        QtCore.QObject.connect(self.button_ExpandAll, QtCore.SIGNAL(_fromUtf8("released()")), self.inspector.expandAll)
        QtCore.QObject.connect(self.button_CollapseAll, QtCore.SIGNAL(_fromUtf8("released()")), self.inspector.collapseAll)
        QtCore.QObject.connect(self.lineEdit, QtCore.SIGNAL(_fromUtf8("returnPressed()")), self.button_Search.click)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QtGui.QApplication.translate("MainWindow", "Trickplay UI Tree Viewer", None, QtGui.QApplication.UnicodeUTF8))
        self.menuFile.setTitle(QtGui.QApplication.translate("MainWindow", "File", None, QtGui.QApplication.UnicodeUTF8))
        self.dockWidget_2.setWindowTitle(QtGui.QApplication.translate("MainWindow", "  UI Elements", None, QtGui.QApplication.UnicodeUTF8))
        self.button_Refresh.setText(QtGui.QApplication.translate("MainWindow", "Refresh", None, QtGui.QApplication.UnicodeUTF8))
        self.button_ExpandAll.setText(QtGui.QApplication.translate("MainWindow", "Expand All", None, QtGui.QApplication.UnicodeUTF8))
        self.button_CollapseAll.setText(QtGui.QApplication.translate("MainWindow", "Collapse All", None, QtGui.QApplication.UnicodeUTF8))
        self.button_Search.setText(QtGui.QApplication.translate("MainWindow", "Search", None, QtGui.QApplication.UnicodeUTF8))
        self.dockWidget.setWindowTitle(QtGui.QApplication.translate("MainWindow", "  Properties", None, QtGui.QApplication.UnicodeUTF8))
        self.actionExit.setText(QtGui.QApplication.translate("MainWindow", "Exit", None, QtGui.QApplication.UnicodeUTF8))
        self.action_Exit.setText(QtGui.QApplication.translate("MainWindow", "Exit", None, QtGui.QApplication.UnicodeUTF8))

