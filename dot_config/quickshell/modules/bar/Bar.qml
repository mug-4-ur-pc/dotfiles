
import Quickshell

import qs.config

// qmllint disable
PanelWindow {
    // qmllint enable
    required property var modelData
    screen: modelData

    anchors.left: true
    anchors.top: true
    anchors.bottom: true

    color: "#66000000"

    implicitWidth: 40
}
