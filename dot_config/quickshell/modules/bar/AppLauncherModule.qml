
import QtQuick
import Quickshell
import Quickshell.Widgets

import qs.components
import qs.config
import qs.services

BarWidget {
    id: root

    required property ShellScreen targetScreen

    implicitWidth: icon.implicitWidth

    isSelected: MenuState.isOpened(this.targetScreen, MenuState.Type.AppLauncher)

    getPopupText: () => { return "Applications" }

    onLeftClick: () => {
        MenuState.toggle(this.targetScreen, MenuState.Type.AppLauncher);
    }

    ColoredIcon {
        id: icon
        anchors.centerIn: parent
        implicitSize: root.height * Config.bar.iconScale
        icon: "arch-linux-mono.svg"
        color: root.textColor
    }
}
