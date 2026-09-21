import QtQuick

Item {
    id: root
    default property Item content
    data: [content]
    implicitWidth: root.content.implicitWidth
    implicitHeight: root.content.implicitHeight
}
