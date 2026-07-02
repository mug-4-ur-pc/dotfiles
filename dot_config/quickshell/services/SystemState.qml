pragma Singleton

import Quickshell

import qs.config
import qs.services

Singleton {
    id: root

    readonly property bool initialized: {
        Chezmoi.isReady
        && WallpaperService.isInit
    }

    property bool barEnabled: false
    property bool wallpaperEnabled: false
    property bool idleEnabled: false

    readonly property bool isLaptop: Chezmoi.data?.is_laptop ?? false

    readonly property var screens: {
        root.initialized
        ? [...Quickshell.screens].filter(screen => screen.name !== "")
        : []
    }

    readonly property ShellScreen mainScreen: {
        const filteredScreens = this.screens.filter(screen => screen.name === Config.misc.mainScreenName);
        return filteredScreens.length > 0 ? filteredScreens[0] : this.screens[0] ?? null
    }
}
