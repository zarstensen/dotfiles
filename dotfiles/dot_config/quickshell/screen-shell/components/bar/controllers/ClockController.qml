pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    readonly property string time: Qt.formatDateTime(Date.date, "hh:mm:ss")
    readonly property string date: Qt.formatDateTime(Date.date, "dd-MM-yy")

    FileView {
        id: stateFile
        path: Quickshell.statePath("clock-state.json")
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: persist
            property bool expanded: false
        }
    }

    property alias expanded: persist.expanded
}
