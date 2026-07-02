
import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.components

// qmllint disable
PanelWindow {
    // qmllint enable
    required property ShellScreen modelData
    screen: modelData

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    mask: Region {}
    updatesEnabled: false

    anchors {
        left: true
        top: true
        right: true
        bottom: true
    }

    WallpaperImage { isDecorated: false }
}
