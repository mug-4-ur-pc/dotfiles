
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.config
import qs.utils

Scope {
    id: root

    property bool isDimmed: false
    property bool isLocked: false
    property bool isScreenOff: false

    IdleMonitor {
        timeout: 0
        onIsIdleChanged: {
            if (!this.isIdle) {
                root.isDimmed = false
                root.isScreenOff = false
            }
        }
    }

    IdleMonitor {
        timeout: Config.idle.lockSeconds
        onIsIdleChanged: {
            if (this.isIdle) {
                root.lockScreen();
            }
        }
    }

    IdleMonitor {
        timeout: Config.idle.screenOffSeconds
        onIsIdleChanged: root.isScreenOff = this.isIdle
    }

    IpcHandler {
        target: "idle"

        function turnOffScreen(): void {
            root.isScreenOff = true
        }
    }

    onIsScreenOffChanged: {
        if (this.isScreenOff) {
            Logger.info("Idle", "Screen  turned off");
            this.lockScreen();
        } else {
            Logger.info("Idle", "Screen  turned on");
        }
        WMService.screenEnabled = !this.isScreenOff;
    }

    function lockScreen() {
        Quickshell.execDetached([`${Utils.home}/.config/hyprlock/launch.sh`]);
    }

    Component.onCompleted: {
        Logger.debug("Idle", "Enabled");
    }

    Component.onDestruction: {
        Logger.debug("Idle", "DIsabled");
    }
}
