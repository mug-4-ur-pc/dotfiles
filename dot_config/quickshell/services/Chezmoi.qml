pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs.services
import qs.utils

Singleton {
    id: root

    property var data: undefined
    readonly property bool isReady: data !== undefined

    Process {
        id: dump
        running: true
        command: ["chezmoi", "dump-config", "--format", "json"]
        stdout: StdioCollector {
            onStreamFinished: {
                const data = JSON.parse(this.data).data;
                if (data !== undefined) {
                    Logger.debug("Chezmoi", "Updated chezmoi.data");
                    root.data = data;
                } else {
                    Logger.error("Chezmoi", "Chezmoi config has no data entry");
                }
            }
        }
    }

    FileView {
        id: file
        path: `${Utils.configDir}/chezmoi/chezmoi.toml`
        preload: false
        watchChanges: true
        onFileChanged: root.reload()
    }

    function reload(): void {
        dump.running = true
    }

    function getColor(key: string): color {
        const c = this.data?.theme[key]
        return c === undefined ? "transparent" : `#${c}`
    }
}
