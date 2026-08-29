pragma Singleton

import Quickshell

Singleton {
    id: root

    PersistentProperties {
        id: persist
        reloadableId: "clockExpandState"
        property bool expanded: false
    }

    property alias expanded: persist.expanded
}
