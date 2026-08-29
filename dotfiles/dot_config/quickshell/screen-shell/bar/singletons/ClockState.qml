pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
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
