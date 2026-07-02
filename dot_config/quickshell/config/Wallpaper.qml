
import Quickshell
import Quickshell.Io

JsonObject {
    id: wallpaper
    required property var cfg

    readonly property bool enabled:     cfg?.enabled ?? true
    readonly property string imgPath:   cfg?.imgPath ?? Quickshell.shellPath("assets/wallpaper.jpg")
}
