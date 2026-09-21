import Quickshell.Widgets
import Quickshell.Services.UPower
import QtQuick
import qs.style
import qs.controls
import qs.utils

WrapperItem {
    CenterItem {
        Row {
            Icon {
                id: icon
                source: "/icons/Fluent-light/symbolic/status/battery-level-%1%2-symbolic.svg".arg(String(Math.round(UPower.displayDevice.percentage / 10) * 10)).arg(UPower.displayDevice.state === "Charging" ? "-charging" : "")
                size: Style.fIcon.pixelSize
                color: Style.cText
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: " %1%".arg(UPower.displayDevice.percentage)
                font: Style.fBody
                color: Style.cText
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
