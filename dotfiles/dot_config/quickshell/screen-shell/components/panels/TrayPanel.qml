import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import qs.style
import qs.style.behaviors
import qs.controls
import qs.utils

PopupWindow {
    id: trayPanel
    required property Item item
    property bool open: false
    property int minGridSize: 2
    color: "transparent"
    visible: panel.opacity != 0

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    anchor {
        item: trayPanel.item
        edges: Edges.Top
        gravity: Edges.Top
        margins.top: -Style.nWidgetSpacing
    }

    // context menu anchor? for the context menu which appreas when we right click on tray items.
    QsMenuAnchor {
        id: contextMenu
        anchor.edges: Edges.Top | Edges.Left
        anchor.gravity: Edges.Top | Edges.Left

        // open the context menu with the given menu, and place it at the given item.
        function activate(menu: QsMenuHandle, trayItem: Item) {
            contextMenu.menu = menu;
            contextMenu.anchor.item = trayItem;
            contextMenu.open();
        }
    }

    HyprlandFocusGrab {
        windows: [trayPanel]

        // if the context menu is opened, we dont want to close the tray panel, so check this here,
        // *and* in onCleared.
        active: trayPanel.open && !contextMenu.visible

        onCleared: {
            if (!contextMenu.visible) {
                trayPanel.open = false;
            }
        }
    }

    Rectangle {
        id: panel
        radius: Style.nRadius
        color: Colors.setAlpha(Style.cBackground, 0.8)
        anchors.fill: parent

        opacity: trayPanel.open ? 1 : 0
        FastNumber on opacity {}

        WrapperItem {
            id: content
            anchors.fill: parent
            margin: Style.nWidgetSpacing / 3

            Grid {
                id: trayGrid
                columns: Math.ceil(Math.sqrt(trayItems.length))

                property var trayItems: {
                    const padded_items = [...SystemTray.items.values];
                    while (padded_items.length < trayPanel.minGridSize * trayPanel.minGridSize) {
                        padded_items.push({ icon: "" });
                    }
                    return padded_items;
                }

                Repeater {
                    model: trayGrid.trayItems
                    WrapperMouseArea {
                        id: trayArea
                        required property SystemTrayItem modelData
                        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                        hoverEnabled: true

                        onClicked: mouse => {
                            if (modelData?.menu && (mouse.button == Qt.LeftButton || mouse.button == Qt.RightButton)) {
                                contextMenu.activate(modelData.menu, trayArea);
                            }
                            if (mouse.button == Qt.MiddleButton) {
                                modelData?.secondaryActivate();
                            }
                        }

                        HoverRect {
                            margin: Style.nWidgetSpacing / 3

                            IconImage {
                                id: trayIcon
                                source: trayArea.modelData?.icon ?? ""
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
