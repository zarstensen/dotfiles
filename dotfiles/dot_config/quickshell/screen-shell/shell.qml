//@ pragma Env QS_NO_RELOAD_POPUP=1
// qmllint disable import
// qmllint disable unqualified
import Quickshell
import QtQuick
import qs.bar

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        Bar {}
    }
}
