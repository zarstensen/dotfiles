import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.style
import qs.style.behaviors
import qs.bar.singletons

WrapperMouseArea {
    id: area
    topMargin: 3
    bottomMargin: 3
    hoverEnabled: true

    component Button: Text {
        id: button

        required property color iconColor
        signal clicked

        color: area.containsMouse ? (hover.hovered ? Style.cHover : iconColor) : Style.cText
        XFastColor on color {}

        HoverHandler {
            id: hover
        }
        TapHandler {
            onTapped: clicked()
        }
    }

    WrapperRectangle {
        color: area.containsMouse ? Style.cForeground : Qt.rgba(Style.cForeground.r, Style.cForeground.g, Style.cForeground.b, 0)
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

                Button {
                    id: poweroff
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -1
                    text: "\u23fb"
                    font: Style.fIcon
                    iconColor: Style.cPoweroff
                    onClicked: PowerController.poweroff()
                }

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Style.nWidgetSpacing * 1.5
                    width: area.containsMouse ? implicitWidth : 0
                    Behavior on width {
                        NumberAnimation {
                            duration: Style.aMed
                            easing: Easing.OutCubic
                        }
                    }
                    clip: true
                    Button {
                        id: reboot
                        text: ""
                        font: Style.fIconSm
                        iconColor: Style.cReboot
                        onClicked: PowerController.reboot()
                    }
                    Button {
                        id: lock
                        text: "󰦝"
                        font: Style.fIconSm
                        iconColor: Style.cLock
                        onClicked: PowerController.lock()
                    }
                    Button {
                        id: sleep
                        text: "󱠨"
                        font: Style.fIconSm
                        iconColor: Style.cSleep
                        onClicked: PowerController.sleep()
                    }
                    Button {
                        id: logoff
                        text: ""
                        font: Style.fIconSm
                        iconColor: Style.cLogoff
                        onClicked: PowerController.logoff()
                    }
                }
            }
        }
    }
}
