pragma Singleton

import Quickshell

Singleton {

    function poweroff() {
        Quickshell.execDetached(["hyprshutdown", "--post-cmd", "shutdown now"]);
    }

    function reboot() {
        Quickshell.execDetached(["hyprshutdown", "--post-cmd", "shutdown -r now"]);
    }

    function lock() {
        Quickshell.execDetached(["hyprlock"]);
    }

    function sleep() {
        Quickshell.execDetached(["systemctl", "suspend"]);
        lock()
    }

    function logoff() {
        Quickshell.execDetached(["hyprshutdown"]);
    }
}
