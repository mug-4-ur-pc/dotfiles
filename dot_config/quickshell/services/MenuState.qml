pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    enum Type {
        None,
        AppLauncher
    }

    property ShellScreen targetScreen: null
    property int type: MenuState.Type.None

    function open(screen: ShellScreen, what: int) {
        if (screen == null || what === MenuState.Type.None) {
            screen = null;
            what = MenuState.Type.None;
        }

        this.targetScreen = screen;
        this.type = what;
        if (what !== MenuState.Type.None) {
            Logger.info("MenuService", `Opened menu ${what} on screen ${screen.name}`);
        } else {
            Logger.info("MenuService", "Closed menu");
        }
    }

    function close() {
        this.open(null, MenuState.Type.None);
    }

    function toggle(screen: ShellScreen, what: int) {
        if (what === this.type) {
            this.close();
        } else {
            this.open(screen, what);
        }
    }

    function isOpened(screen: ShellScreen, what = null): bool {
        if (this.targetScreen === null || this.type === MenuState.Type.None) {
            return false;
        }
        if (screen === null) {
            return this.type === what;
        }
        if (what === null) {
            return this.targetScreen === screen;
        }
        return screen === this.targetScreen && what === this.type;
    }

    IpcHandler {
        target: "launcher"
        function open() { root.open(SystemState.mainScreen, MenuState.Type.AppLauncher); }
        function close() { root.close(SystemState.mainScreen, MenuState.Type.AppLauncher); }
        function toggle() { root.toggle(SystemState.mainScreen, MenuState.Type.AppLauncher); }
    }
}
