pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs.config
import qs.utils

Singleton {
    id: root

    readonly property string origPath: Utils.resolve(Config.wallpaper.imgPath)
    readonly property string decoratedPath: Quickshell.cachePath(`DecoratedWallpaper.jpg`)
    readonly property bool isInit: decoratedImageCreator.done || this.isInit

    function reset() {
        decoratedImageCreator.done = false;
        decoratedImageCreator.running = true;
    }

    onOrigPathChanged: this.reset()

    Process {
        id: decoratedImageCreator
        command: [Quickshell.shellPath("assets/scripts/create_muted_wallpaper"), root.origPath, root.decoratedPath]
        onExited: (code) => {
            if (code) {
                Logger.warn("Wallpaper", `Can't create decorated wallpaper. Exit code ${code}`);
                Logger.warn("Wallpaper", `${root.origPath}, ${root.decoratedPath}`);
            }
            this.done = true;
        }
        property bool done: false
    }
}
