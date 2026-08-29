import Quickshell.Widgets
import qs.style
import qs.style.behaviors
import qs.utils

WrapperRectangle {
    required property bool isHovered
    radius: Style.nRadius
    color: isHovered ? Colors.setAlpha(Style.cBackground, 0.6) : Colors.setAlpha(Style.cBackground, 0)
    FastColor on color {}
}
