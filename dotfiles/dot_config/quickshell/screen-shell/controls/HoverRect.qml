import Quickshell.Widgets
import QtQuick
import qs.style
import qs.style.behaviors
import qs.utils

WrapperRectangle {
    radius: Style.nRadius
    color: hoverHandler.hovered ? Colors.setAlpha(Style.cBackgroundMuted, 0.8) : Colors.setAlpha(Style.cBackgroundMuted, 0)
    FastColor on color {}

    HoverHandler {
        id: hoverHandler
    }
}
