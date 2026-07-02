//@ pragma CacheDir $BASE/quickshell/m4up
//@ pragma StateDir $BASE/quickshell/m4up
//@ pragma DataDir $BASE/quickshell/m4up

import QtQuick
import Quickshell

import qs.config
import qs.services

import qs.modules.bar
import qs.modules.wallpaper

ShellRoot {
    id: root

    Variants {
        model: SystemState.screens
        Scope {
            id: screenScope
            required property ShellScreen modelData

            LazyLoader {
                active: SystemState.barEnabled
                component: Bar { modelData: screenScope.modelData }
            }

            LazyLoader {
                active: SystemState.wallpaperEnabled
                component: Wallpaper { modelData: screenScope.modelData }
            }

            Component.onCompleted: {
                Logger.debug("ShellRoot", `Initialized components on screen ${modelData}`);
            }
        }
    }

    Loader {
        active: SystemState.initialized
        sourceComponent: Scope {
            LazyLoader {
                active: SystemState.idleEnabled
                component: IdleService {}
            }

            Component.onCompleted: {
                SystemState.barEnabled = Config.bar.enabled;
                SystemState.wallpaperEnabled = Config.wallpaper.enabled;
                SystemState.idleEnabled = Config.idle.enabled;

                Logger.debug("ShellRoot", `Initialized shared components`);
            }
        }
    }
}
