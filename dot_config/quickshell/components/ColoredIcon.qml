
import QtQuick
import QtQuick.Effects
import Quickshell.Widgets

import qs.utils

IconImage {
    id: root

    property string icon: ""
    property color color: "black"

    source: Utils.iconFile(this.icon)
    asynchronous: true

     layer.enabled: true
    layer.effect: MultiEffect {
        brightness: 1.0
        colorization: 1.0
        colorizationColor: root.color
    }
}
