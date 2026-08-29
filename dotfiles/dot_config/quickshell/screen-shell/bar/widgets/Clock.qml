// qmllint disable uncreatable-type
// qmllint disable import
// qmllint disable unqualified
// qmllint disable missing-property
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.style
import qs.style.behaviors
import qs.components.bar.controllers

// mouse widget, clikc to expose a date label under the time label

WrapperMouseArea {
    id: clockArea
    onClicked: ClockController.expanded = !ClockController.expanded

    // wrap the column in a item such that when WrapperMouseArea resizes and moves the child,
    // its only the *item* which is stretched, but the column itself is kept in the center of the item.
    // we need to set the implicitWidth and Height still so the WrapperMouseArea knows what the
    // minimum width and height is for the widget
    Item {
        implicitWidth: clockCol.implicitWidth
        implicitHeight: clockCol.implicitHeight

        Column {
            id: clockCol
            anchors.centerIn: parent

            Label {
                color: Style.cText
                font: Style.fBody
                text: ClockController.time
            }

            // separator between time and date when expanded
            Rectangle {
                color: Style.cText
                // the height of this rectangle grows for some reason when the date label is removed, so
                // here we just shrink it a bit when we collapse the clock widget to counteract this behaviour
                height: ClockController.expanded ? 1 : 0.8
                FastNumber on height {}
                width: ClockController.expanded ? clockCol.implicitWidth : 0
                FastNumber on width {}
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: 0.4
            }

            Label {
                opacity: ClockController.expanded ? 1 : 0
                FastNumber on opacity {}
                height: ClockController.expanded ? implicitHeight : 0
                FastNumber on height {}
                visible: opacity > 0
                color: Style.cText
                font: Style.fBody
                text: ClockController.date
            }
        }
    }
}
