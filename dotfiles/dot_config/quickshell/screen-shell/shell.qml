//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
// qmllint disable import
// qmllint disable unqualified
import Quickshell
import QtQuick
import qs.components.bar

Scope {
    Variants {
        model: Quickshell.screens

        Bar {}
    }
}
