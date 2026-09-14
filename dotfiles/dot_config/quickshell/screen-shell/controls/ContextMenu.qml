import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.style
import qs.utils

PopupWindow {
    id: ctxMenu
    property QsMenuHandle menu
    implicitWidth: Math.max(40, view.implicitWidth)
    implicitHeight: Math.max(40, view.implicitHeight)
    color: "transparent"

    function open(item, x, y) {
        anchor.item = item;
        anchor.rect.x = x;
        anchor.rect.y = y;
        visible = true;
        forceActiveFocus();
        // TODO: why?
        Qt.callLater(() => ctxMenu.anchor.updateAnchor());
    }

    QsMenuOpener {
        id: opener
        menu: ctxMenu.menu
    }

    // background
    Rectangle {
        anchors.fill: parent
        color: Style.cBackground
        radius: Style.nRadius
    }

    ColumnLayout {
        id: view
        spacing: 0

        Repeater {

            model: ScriptModel {
                values: opener.children ? [...opener.children.values] : []
            }

            delegate: Rectangle {
                id: entry
                required property var modelData

                Layout.fillWidth: true

                implicitHeight: (modelData?.isSeparator) ? 8 : 32
                implicitWidth: entryContent.implicitWidth
                color: "transparent"
                radius: Style.nRadius

                Loader {
                    id: entryContent
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    sourceComponent: (modelData?.isSeparator ?? false) ? separatorEntry : ctxEntry
                }
                // separator entry
                Component {
                    id: separatorEntry
                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        implicitHeight: 1
                        color: Style.cTextMuted
                        visible: modelData?.isSeparator ?? false
                    }
                }

                // actual entry
                Component {
                    id: ctxEntry
                    HoverRect {
                        anchors.fill: parent
                        visible: !(modelData?.isSeparator ?? false)

                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        // the entry itself, has some text + potentially an icon
                        RowLayout {
                            anchors.fill: parent
                            spacing: 8

                            Text {
                                Layout.fillWidth: true
                                text: modelData?.text ?? ""
                                font: Style.fBodySm
                                verticalAlignment: Text.AlignVCenter
                                // elide: Text.ElideRight

                                DebugBox {}
                            }

                            Image {
                                Layout.preferredWidth: Style.fIconSm.pixelSize
                                Layout.preferredHeight: Style.fIconSm.pixelSize
                                source: modelData?.icon ?? ""
                                visible: (modelData?.ion ?? "") !== ""
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: (modelData?.enabled ?? true) && !(modelData?.isSeparator ?? false) || ctxMenu.visible

                    onClicked: {
                        if (modelData && !modelData.isSeparator) {
                            modelData.triggered();
                            ctxMenu.visible = false;
                        }
                    }
                }
            }
        }
    }
}
