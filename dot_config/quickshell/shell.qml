//@ pragma CacheDir $BASE/quickshell/m4up
//@ pragma StateDir $BASE/quickshell/m4up
//@ pragma DataDir $BASE/quickshell/m4up

pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import qs.modules.bar
import qs.services

ShellRoot {
    id: root

    Variants {
        model: SystemState.initialized ? Quickshell.screens : []
        Scope {
            id: screenScope
            required property var modelData

            LazyLoader {
                activeAsync: SystemState.barEnabled
                component: Bar { modelData: screenScope.modelData }
            }

            Component.onCompleted: {
                Logger.debug("ShellRoot", `Initialized components on screen ${modelData}`);
            }
        }
    }
}
