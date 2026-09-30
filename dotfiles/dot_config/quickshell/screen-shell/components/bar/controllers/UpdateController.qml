pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property list<string> pendingUpdates: []

    readonly property list<string> vitalPackageGroups: ["base", "base-devel", "linux-firmware"]
    property list<string> vitalPackages: []

    property bool hasUpdates: pendingUpdates.some(p => vitalPackages.indexOf(p) >= 0) || pendingUpdates.length > 20

    // Coalesce refresh requests so a slow checkupdates never eats one.
    property bool refreshPending: false

    Process {
        id: checkUpdate
        command: ["checkupdates", "--nocolor"]

        property list<string> collectedPackages: []

        stdout: SplitParser {
            onRead: pendingUpdate => {
                checkUpdate.collectedPackages.push(pendingUpdate.split(" ")[0]);
            }
        }
        running: true

        onStarted: {
            checkUpdate.collectedPackages = [];
        }

        onExited: { // qmllint disable
            pendingUpdates = checkUpdate.collectedPackages;
        }
    }

    Variants {
        model: vitalPackageGroups
        delegate: Component {
            Process {
                required property var modelData
                command: ["pactree", "-l", "-d", "1", modelData]
                running: true

                stdout: SplitParser {
                    onRead: package => {
                        vitalPackages.push(package);
                    }
                }
            }
        }
    }

    Timer {
        id: checkUpdateTimer
        interval: 30 * 60 * 1000 // 30 minutes
        running: true
        repeat: true
        onTriggered: checkUpdate.running = true
    }

    // pacman drops a new <name>-<ver> directory into the local database for
    // every package it installs, so any real transaction fires a burst of
    // inotify events here. Reading the path as a file fails harmlessly
    // (preload is off), but the directory itself is watched.
    FileView {
        id: pacmanDbWatch
        path: "/var/lib/pacman/local"
        watchChanges: true
        preload: false
        printErrors: false
        onFileChanged: pacmanSettle.restart()
    }

    // Debounce the burst, then re-check a few seconds after the last write.
    Timer {
        id: pacmanSettle
        interval: 5000
        repeat: false
        onTriggered: checkUpdate.running = true
    }
}
