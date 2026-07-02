pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import qs.config

Item {
    id: root

    default property alias data: popupWindow.data

    property bool show: false
    property bool showDelayed: false
    readonly property alias opened: popupWindow.visible
    readonly property bool blocked: hoverHandler.hovered

    Timer {
        id: timer
        interval: root.showDelayed ? Config.popups.delay : 0
        running: false
        onTriggered: {
            if (!root.blocked) {
                popupWindow.visible = !popupWindow.visible
            }
        }
    }

    onShowChanged: this._toggle(this.show)
    onBlockedChanged: this._toggle(this.blocked)

    function _toggle(on: bool) {
        timer.stop();
        if (on != this.opened) {
            timer.restart();
        }
    }

    PopupWindow {
        id: popupWindow
        visible: false

        anchor {
            adjustment: PopupAdjustment.All
            edges: Edges.Bottom | Edges.Right
            gravity: Edges.Top | Edges.Right
            item: root.parent
        }

        implicitWidth: root.implicitWidth
        implicitHeight: root.implicitHeight
        color: "transparent"

        MouseArea {
            id: hoverHandler
            anchors.fill: parent
            hoverEnabled: true
            readonly property bool hovered: this.containsMouse
        }
    }
}
