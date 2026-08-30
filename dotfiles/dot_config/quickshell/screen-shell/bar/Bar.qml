// qmllint disable uncreatable-type
// qmllint disable import
// qmllint disable unqualified
// qmllint disable missing-property
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.style
import qs.utils
import qs.components.bar.widgets

PanelWindow {
    required property var modelData

    WlrLayershell.namespace: "bar"
    screen: modelData
    implicitHeight: Style.nBarHeight
    color: Colors.setAlpha(Style.cBackground, 0.1)

    anchors {
        bottom: true
        left: true
        right: true
    }

    RowLayout {
        id: left

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

        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            rightMargin: (Style.nBarHeight - Style.fBody.pixelSize * 0.9) / 2
        }

        Tray {
            Layout.fillHeight: true
            leftMargin: Style.nWidgetSpacing / 2
            rightMargin: Style.nWidgetSpacing / 2
        }

        Clock {
            Layout.fillHeight: true
            leftMargin: Style.nWidgetSpacing / 2
        }
    }
}
