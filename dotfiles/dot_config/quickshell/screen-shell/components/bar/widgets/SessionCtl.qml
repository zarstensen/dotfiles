import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.style
import qs.style.behaviors
import qs.controls
import qs.components.bar.controllers
import qs.utils

Cell {
    component Button: Text {
        id: button

        property Cell cell
        required property color iconColor
        signal clicked

        color: cell.containsMouse ? (hover.hovered ? Style.cHover : iconColor) : Style.cText
        XFastColor on color {}

        HoverHandler {
            id: hover
        }
        TapHandler {
            onTapped: button.clicked()
        }
    }

    mainComponent: Component {
        Button {
            id: poweroff
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -1
            text: "\u23fb"
            font: Style.fIcon
            iconColor: Style.cPoweroff
            onClicked: PowerController.poweroff()
        }
    }

    components: [
        Component {
            Button {
                id: reboot
                text: ""
                font: Style.fIconSm
                iconColor: Style.cReboot
                onClicked: PowerController.reboot()
            }
        },
        Component {
            Button {
                id: lock
                text: "󰦝"
                font: Style.fIconSm
                iconColor: Style.cLock
                onClicked: PowerController.lock()
            }
        },
        Component {
            Button {
                id: sleep
                text: "󱠨"
                font: Style.fIconSm
                iconColor: Style.cSleep
                onClicked: PowerController.sleep()
            }
        },
        Component {
            Button {
                id: logoff
                text: ""
                font: Style.fIconSm
                iconColor: Style.cLogoff
                onClicked: PowerController.logoff()
            }
        }
    ]
}
