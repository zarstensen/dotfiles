pragma Singleton

import QtQuick
import Quickshell

Singleton {
    function setAlpha(c: color, a: real): color {
        return Qt.rgba(c.r, c.g, c.b, a);
    }
}
