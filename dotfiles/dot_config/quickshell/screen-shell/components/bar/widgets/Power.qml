import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.style
import qs.style.behaviors
import qs.controls
import qs.components.bar.controllers
import qs.utils

Cell {
    mainComponent: Component {
        Text {
            property Cell cell
            text: ""
            font: Style.fIcon
            color: cell.containsMouse ? (hover.hovered ? Style.cHover : iconColor) : Style.cText
        }
    }
    Component.onCompleted: {
        console.log(UPowerDeviceType.toString(UPower.displayDevice.type));
        console.log(UPower.displayDevice.model);
        console.log(UPower.displayDevice.powerSupply);
    }
    components: []
}
