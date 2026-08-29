// TODO: tooltips
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import qs.style
import qs.controls
import qs.utils

PopupWindow {
    id: trayPanel
    required property Item item
    color: "transparent"

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    anchor {
        item: trayPanel.item
        edges: Edges.Top
        gravity: Edges.Top
        margins.top: -Style.nWidgetSpacing
    }

    Rectangle {
        id: panel
        radius: Style.nRadius
        color: Colors.setAlpha(Style.cBackground, 0.8)
        anchors.fill: parent

        WrapperItem {
            id: content
            anchors.fill: parent
            margin: Style.nWidgetSpacing / 3

            Grid {
                id: trayGrid
                columns: Math.ceil(Math.sqrt(SystemTray.items.values.length))

                Repeater {
                    model: SystemTray.items
                    WrapperMouseArea {
                        id: trayArea
                        required property SystemTrayItem modelData
                        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                        hoverEnabled: true

                        onClicked: mouse => {
                            console.log(mouse.button);
                            if (mouse.button == Qt.LeftButton) {
                                modelData.activate();
                            }
                            if (mouse.button == Qt.MiddleButton) {
                                modelData.secondaryActivate();
                            }
                            if (mouse.button == Qt.RightButton) {
                                let global_pos = trayArea.mapToItem(trayPanel.contentItem, mouse.x, mouse.y)
                                modelData.display(trayPanel, global_pos.x, global_pos.y);
                            }
                        }

                        HoverRect {
                            margin: Style.nWidgetSpacing / 3
                            isHovered: trayArea.containsMouse

                            IconImage {
                                id: trayIcon
                                source: modelData.icon
                                asynchronous: true
                                implicitSize: Style.fIconSm.pixelSize
                            }
                        }
                    }
                }
            }
        }
    }
}
