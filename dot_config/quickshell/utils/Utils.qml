pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property string home: Quickshell.env("HOME")

    readonly property string configDir: {
        const xdg = Quickshell.env("XDG_CONFIG_HOME") ?? ""
        return xdg != "" ? xdg : `${this.home}/.config`
    }

    function resolve(p: string): string {
        if (p.startsWith("~/")) {
            p = p.replace("~/", `${this.home}/`)
        }
        return p
    }

    function iconFile(fname: string): string {
        fname = Quickshell.shellPath(`assets/icons/${fname}`);
        return `file://${fname}`;
    }

    function setColorOpacity(color: color, opacity: real): color {
        return Qt.rgba(color.r, color.g, color.b, opacity)
    }

    function createBinding(objFrom: QtObject, propFrom: string, objTo: QtObject, propTo: string, sync = true) {
        const updateProp = () => {
            if (objTo[propTo] !== objFrom[propFrom]) {
                objTo[propTo] = objFrom[propFrom];
            }
        }

        if (sync) {
            updateProp()
        }

        var signal = objFrom[propFrom + "Changed"];
        if (signal) {
            signal.connect(updateProp);
        } else {
            Logger.warn("Binding", `Could not find change signals for propery ${propFrom}`);
        }
    }

    function createTwoWayBinding(objA: QtObject, propA: string, objB: QtObject, propB: string, sync = false) {
        this.createBinding(objB, propB, objA, propA, false)
        this.createBinding(objA, propA, objB, propB, sync)
    }
}
