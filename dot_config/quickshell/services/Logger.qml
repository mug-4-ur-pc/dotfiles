pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property int levelDebug: 1
    readonly property int levelInfo: 2
    readonly property int levelWarn: 3
    readonly property int levelError: 4

    readonly property int minLevel: {
        const envDebug = Quickshell.env("QS_DEBUG")
        const isDebug = envDebug === "1" || envDebug === "true"
        return isDebug ? this.levelDebug : this.levelInfo
    }

    readonly property bool debugMode: this.levelDebug >= this.minLevel

    Component.onCompleted: {
        if (this.debugMode) {
            this.debug("Logger", "Debug mode enabled (QS_DEBUG=1)")
        }
    }

    function _toString(obj): string {
        if (obj instanceof Error) {
            return obj.message;
        }
        if (typeof obj === 'string') {
            return obj;
        }
        if (obj === undefined) {
            return '';
        }
        if (obj === null) {
            return "null";
        }
        return JSON.stringify(obj);
    }

    function _prepareMessage(component, msg, details): string {
        let res = `[${component}] ${_toString(msg)}`;
        if (details !== undefined) {
            res += `: ${_toString(details)}`;
        }
        return res;
   }

    function debug(component, msg) {
        if (this.levelDebug >= minLevel) {
            console.debug(_prepareMessage(component, msg))
        }
    }

    function info(component, msg) {
        if (this.levelInfo >= minLevel) {
            console.info(_prepareMessage(component, msg))
        }
    }

    function warn(component, msg) {
        if (this.levelWarn >= minLevel) {
            console.warn(_prepareMessage(component, msg))
        }
    }

    function error(component, msg, details) {
        if (this.levelError >= minLevel) {
            console.error(_prepareMessage(component, msg, details))
        }
    }

    property var timers: ({})

    function timeStart(label) {
        this.timers[label] = new Date().getTime()
    }

    function timeEnd(label) {
        if (this.timers[label]) {
            const elapsed = new Date().getTime() - timers[label]
            this.debug("Performance", `${label}: ${elapsed}ms`)
            delete this.timers[label]
        }
    }
}

