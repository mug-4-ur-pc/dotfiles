pragma Singleton

import QtQuick
import Quickshell

import qs.utils

import qs.services.window_managers as WindowManagers

Singleton {
    id: root

    readonly property string currentWM: {
        const desktop = Quickshell.env("XDG_CURRENT_DESKTOP") || "";
        return desktop.toLowerCase();
    }

    property bool screenEnabled: provider.screenEnabled
    property list<string> logoutCnd: provider.logoutCmd

    Loader {
        id: wmLoader
        sourceComponent: {
            Logger.debug("WMService", `Window manager: ${root.currentWM}`)

            if (root.currentWM.includes("niri")) return niriComponent;

            Logger.warn("WMService", `Unsupported window manager: ${root.currentWM}`);
            return dummyComponent
        }
    }
    Component { id: niriComponent; WindowManagers.Niri {} }
    Component { id: dummyComponent; WindowManagers.DummyWM {} }

    readonly property WindowManagers.WMInterface provider: wmLoader.item

    function logout() {
        Quickshell.execDetached(this.logoutCmd);
    }

    Component.onCompleted: {
        const blacklist = [
            "objectName",
            "reloadableId",
            "children",
            "provider",
            "currentWM",
        ];

        Object.keys(root).filter(prop =>
            prop in root.provider
            && !blacklist.includes(prop)
            && typeof root[prop] !== "function"
        ).forEach(prop => {
            Utils.createTwoWayBinding(root.provider, prop, root, prop);
        });
    }
}
