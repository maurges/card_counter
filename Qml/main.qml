import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "./Landing/" as Landing

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Stack")

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        RowLayout {
            width: parent.width

            ToolButton {
                id: toolButton
                icon.source: stackView.depth > 1 ? "qrc:/Assets/arrow_back.svg" : "qrc:/Assets/menu.svg"
                onClicked: {
                    if (stackView.depth > 1) {
                        stackView.pop()
                    } else {
                        drawer.open()
                    }
                }
            }

            Label {
                text: stackView.currentItem.title
                Layout.fillWidth: true
                font.bold: true
            }

            // all page's buttons go here
            Row {
                data: stackView.currentItem.toolButtons
            }
        }
    }

    Drawer {
        id: drawer
        width: window.width * 0.66
        height: window.height

        Column {
            anchors.fill: parent

            ItemDelegate {
                text: qsTr("View all cards")
                width: parent.width
                onClicked: {
                    var item = Qt.resolvedUrl("./DeckBuild/CardsOnlyPage.qml")
                    stackView.openPage(item, {})
                    drawer.close()
                }
            }
        }
    }

    StackView {
        id: stackView

        function openPage(item, properties) {
            var newItem = stackView.push(item, properties)
            if (newItem == null) {
                console.log("Couldn't create a page!")
            } else {
                connectStackActions(newItem)
            }
        }

        function backPage() {
            var should = stackView.currentItem.beforeClose()
            if (should) {
                stackView.pop()
            }
        }

        function connectStackActions(item) {
            item.openPage.connect(stackView.openPage)
            item.backPage.connect(stackView.backPage)
        }

        initialItem: Landing.Page {
            id: initial
            Component.onCompleted: stackView.connectStackActions(initial)
        }
        anchors.fill: parent
    }

    onClosing: {
        close.accepted = false
        if (stackView.depth > 1)  stackView.backPage()
        else                      window.lower() // doesn't work, but fuck it
    }
    //Keys.onBackPressed: stackView.backPage()
    Keys.onEscapePressed: stackView.backPage()
}
