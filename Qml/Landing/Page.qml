import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.1
import CppTypes 1.0
import "../MyControls" as MC


MC.Page {
    id: page
    title: qsTr("Card counter")

    ListView {
        id: listView
        anchors.fill: parent

        model: SqlTableModel {tableName: "games"}

        ScrollBar.vertical: ScrollBar {
             policy: ScrollBar.AsNeeded
        }

        footer: MC.Button {
            width: parent.width
            text: qsTr("Create deck")
            onClicked: {
                listView.model.create(listView.model.rowCount())
            }
        }

        delegate: MC.DelegateButton {
            id: control
            width: parent.width
            text: model.title

            onClicked: {
                // start a game
                var item = Qt.resolvedUrl("../GameView/Page.qml")
                var props = {"gameId": model.rowid}
                page.openPage(item, props)
            }

            onPressAndHold: contextMenu.open()

            Menu {
                id: contextMenu

                MenuItem {
                    text: qsTr("Edit deck")
                    onClicked: {
                        var item = Qt.resolvedUrl("../DeckBuild/Page.qml")
                        var props = {"gameId": model.rowid}
                        page.openPage(item, props)
                    }
                }
                MenuItem {
                    text: qsTr("Clone deck")
                    onClicked: {
                        listView.model.clone(index)
                        renameDialog.open()
                    }
                }
                MenuItem {
                    text: qsTr("Rename")
                    onClicked: renameDialog.open()
                }
                MenuItem {
                    text: qsTr("Delete deck")
                    onClicked: deleteDialog.open()

                    MessageDialog {
                        id: deleteDialog
                        title: qsTr("Confirm deletion")
                        text: qsTr("Really delete deck %1?").arg(model.title)

                        standardButtons: StandardButton.Ok | StandardButton.Cancel
                        onAccepted: {
                            listView.model.remove(index)
                        }
                        onRejected: {}
                    }
                }
            }
            Dialog {
                id: renameDialog
                title: qsTr("Rename")

                TextField {
                    id: nameLabel
                    // avoid binding loops with one assignment
                    Component.onCompleted: {text = model.title}
                }

                standardButtons: StandardButton.Ok | StandardButton.Cancel
                onAccepted: {
                    model.title = nameLabel.text
                }
                onRejected: {}
            }
        }
    }
}
