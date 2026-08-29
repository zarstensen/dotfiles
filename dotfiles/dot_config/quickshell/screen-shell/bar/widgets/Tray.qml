import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import qs.style

Row {
    spacing: Style.nWidgetSpacing * 1.5

    Repeater {
        model: SystemTray.items

        IconImage {
            required property SystemTrayItem modelData

            source: modelData.icon
            asynchronous: true
            implicitSize: Style.fIconSm.pixelSize
        }
    }
}
