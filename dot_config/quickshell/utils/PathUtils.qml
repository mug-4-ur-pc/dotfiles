pragma Singleton

import Quickshell

Singleton {
    readonly property string home: Quickshell.env("HOME")

    readonly property string configDir: {
        const xdg = Quickshell.env("XDG_CONFIG_HOME") ?? ""
        return xdg != "" ? xdg : `${this.home}/.config`
    }
}
