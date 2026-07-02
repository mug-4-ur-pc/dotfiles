
import QtQuick
import Quickshell
import Quickshell.Io

WMInterface {
    id: root

    onScreenEnabledChanged: {
        if (this.screenEnabled) {
            Quickshell.execDetached(["niri", "msg", "action", "power-on-monitors"])
        } else {
            Quickshell.execDetached(["niri", "msg", "action", "power-off-monitors"])
        }
    }

    Process {
        id: listener
        command: ["niri", "msg", "--json", "event-stream"]
    }
}
