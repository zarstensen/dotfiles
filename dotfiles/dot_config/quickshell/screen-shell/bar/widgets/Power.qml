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

        required property color iconColor
        signal clicked

        color: (hover.hovered ? Style.cHover : iconColor)
        XFastColor on color {}

        HoverHandler {
            id: hover
        }
        TapHandler {
            onTapped: button.clicked()
        }
    }

    mainComponent: Button {
        id: poweroff
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -1
        text: "\u23fbTEST"
        font: Style.fIcon
        iconColor: Style.cPoweroff
        onClicked: PowerController.poweroff()
    }

    components: [
        Button {
            id: reboot
            text: ""
            font: Style.fIconSm
            iconColor: Style.cReboot
            onClicked: PowerController.reboot()
        },
        Button {
            id: lock
            text: "󰦝"
            font: Style.fIconSm
            iconColor: Style.cLock
            onClicked: PowerController.lock()
        },
        Button {
            id: sleep
            text: "󱠨"
            font: Style.fIconSm
            iconColor: Style.cSleep
            onClicked: PowerController.sleep()
        },
        Button {
            id: logoff
            text: ""
            font: Style.fIconSm
            iconColor: Style.cLogoff
            onClicked: PowerController.logoff()
        }
    ]
}
