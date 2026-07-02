
import Quickshell.Io

JsonObject {
    id: idle
    required property var cfg

    readonly property bool enabled: cfg?.enabled ?? true

    readonly property int lockSeconds: cfg?.lockSeconds ?? 5 * 60
    readonly property int screenOffSeconds: cfg?.screenOffSeconds ?? 7.5 * 60
}
