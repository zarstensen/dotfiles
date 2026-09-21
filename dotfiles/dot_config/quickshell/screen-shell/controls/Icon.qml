import QtQuick
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import QtCore

Item {
    id: iconItem
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    required property string source
    required property real size
    required property color color

    readonly property IconImage icon: icon
    readonly property ColorOverlay overlay: overlay

    IconImage {
        id: icon
        source: StandardPaths.writableLocation(StandardPaths.GenericDataLocation) + iconItem.source
        implicitSize: iconItem.size
        asynchronous: true
        visible: false
    }

    ColorOverlay {
        id: overlay
        anchors.fill: icon
        source: icon
        color: iconItem.color
    }
}
