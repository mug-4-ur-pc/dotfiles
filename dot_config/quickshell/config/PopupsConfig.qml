
import Quickshell.Io

JsonObject {
    id: popups
    required property var cfg

    readonly property int delay: cfg?.delay ?? 300
    readonly property int verticalMargins: cfg?.verticalMargins ?? 30
    readonly property int horizontalMargins: cfg?.horizontalMargins ?? 25
    readonly property int maxWidth: cfg?.maxWidth ?? 400

    readonly property int radius: cfg?.radius ?? 30
}
