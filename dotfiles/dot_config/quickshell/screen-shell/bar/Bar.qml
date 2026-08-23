// qmllint disable uncreatable-type
// qmllint disable import
// qmllint disable unqualified
// qmllint disable missing-property
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.style
import qs.bar.widgets

PanelWindow {
    required property var modelData

    WlrLayershell.namespace: "bar"
    screen: modelData
    implicitHeight: Style.nBarHeight
    color: Qt.rgba(Style.cBackground.r, Style.cBackground.g, Style.cBackground.b, 0.1)

    anchors {
        bottom: true
        left: true
        right: true
    }

    RowLayout {
        id: left
        spacing: Style.nWidgetSpacing

        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        Power {
            Layout.fillHeight: true
        }
    }

    RowLayout {
        id: right
        spacing: Style.nWidgetSpacing

        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            rightMargin: (Style.nBarHeight - Style.fBody.pixelSize * 0.9) / 2
        }

        Tray {
            Layout.fillHeight: true
        }

        Clock {
            Layout.fillHeight: true
        }
    }
}
