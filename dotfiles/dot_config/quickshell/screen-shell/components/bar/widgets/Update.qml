import Quickshell.Widgets
import QtQuick
import qs.controls
import qs.style
import qs.components.bar.controllers
import qs.style.behaviors

WrapperItem {
    CenterItem {
        Icon {
            id: updateIcon
            source: "/icons/Fluent-light/symbolic/status/sync-synchronizing-symbolic.svg"
            size: Style.fIconSm.pixelSize
            color: Style.cText
            anchors.verticalCenter: parent.verticalCenter

            MedNumber on rotation {}

            NumberAnimation {
                target: updateIcon
                property: "rotation"
                from: 0
                to: -179
                duration: 2000
                loops: Animation.Infinite
                running: hoverHandler.hovered

                onRunningChanged: {
                    if (!running) {
                        updateIcon.rotation = 0;
                    }
                }
            }
        }
    }

    HoverHandler {
        id: hoverHandler
    }
}
