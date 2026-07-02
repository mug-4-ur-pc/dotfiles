import QtQuick
import Quickshell.Wayland

import qs.config

Item {
    id: root

    width: Config.bar.activeWindowWidth

    Behavior on opacity {
        NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
    }

    Text {
        id: textContainer
        anchors.fill: parent

        color: Config.theme.surfaceFg

        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.family: Config.font.serif
        font.pixelSize: parent.height * Config.bar.activeWindowScale
        font.weight: Font.Bold
    }

    readonly property string activeWindowName: ToplevelManager.activeToplevel?.title ?? ""

    onActiveWindowNameChanged: {
        if (activeWindowName !== "") {
            textContainer.text = activeWindowName;
            this.opacity = 1.0
        } else {
            this.opacity = 0.0
        }
    }
}
