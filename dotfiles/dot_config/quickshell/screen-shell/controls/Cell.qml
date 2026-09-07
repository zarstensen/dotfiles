import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.style
import qs.style.behaviors
import qs.components.bar.controllers
import qs.utils

WrapperMouseArea {
    id: cell
    topMargin: 3
    bottomMargin: 3
    hoverEnabled: true

    required property Component mainComponent
    required property list<Component> components

    WrapperRectangle {
        color: cell.containsMouse ? Style.cForeground : Colors.setAlpha(Style.cForeground, 0)
        FastColor on color {}
        radius: 15
        readonly property real hPadding: (Style.nBarHeight - Style.fIcon.pixelSize * 0.8) / 2
        leftMargin: hPadding
        rightMargin: hPadding

        Item {
            implicitWidth: row.implicitWidth
            implicitHeight: row.implicitHeight

            Row {
                id: row
                anchors.verticalCenter: parent.verticalCenter
                spacing: Style.nWidgetSpacing * 1.5

                Loader {
                    sourceComponent: cell.mainComponent
                    onLoaded: item.cell = cell
                }

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Style.nWidgetSpacing * 1.5
                    width: cell.containsMouse ? implicitWidth : 0
                    Behavior on width {
                        NumberAnimation {
                            duration: Style.aMed
                            easing: Easing.OutCubic
                        }
                    }
                    clip: true

                    Repeater {
                        model: cell.components
                        Loader {
                            sourceComponent: modelData
                            onLoaded: item.cell = cell
                        }
                    }
                }
            }
        }
    }
}
