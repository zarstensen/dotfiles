import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import qs.style
import qs.style.behaviors
import qs.components.panels

WrapperMouseArea {
    id: trayWidget

    onClicked: trayPanel.open = !trayPanel.open

    property real heightScale: trayPanel.open ? -0.15 : 0.15

    MedNumber on heightScale {}
    onHeightScaleChanged: widgetCanvas.requestPaint()

    Item {
        implicitWidth: widgetCanvas.implicitWidth
        implicitHeight: widgetCanvas.implicitHeight

        Canvas {
            id: widgetCanvas
            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: Style.fIconSm.pixelSize * 0.75
            implicitHeight: Style.fIconSm.pixelSize

            onPaint: {
                let ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                ctx.strokeStyle = Style.cText;
                ctx.lineWidth = Style.fIconSm.pixelSize * (1 / 20);

                ctx.lineCap = "round";
                ctx.lineJoin = "round";

                let side_pad = 0.1;

                ctx.beginPath();
                ctx.moveTo(width * side_pad, height * (0.5 + heightScale));
                ctx.lineTo(width * 0.5, height * (0.5 - heightScale));
                ctx.lineTo(width * (1 - side_pad), height * (0.5 + heightScale));
                ctx.stroke();
            }

            TrayPanel {
                id: trayPanel
                item: trayWidget
            }
        }
    }
}

// Row {
//     spacing: Style.nWidgetSpacing
//
//     Repeater {
//         model: SystemTray.items
//
//         IconImage {
//             required property SystemTrayItem modelData
//
//             source: modelData.icon
//             asynchronous: true
//             implicitSize: Style.fIconSm.pixelSize
//         }
//     }
// }
