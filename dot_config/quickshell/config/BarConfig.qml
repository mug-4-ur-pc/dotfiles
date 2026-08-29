
import Quickshell.Io

JsonObject {
    id: bar
    required property var cfg

    readonly property bool enabled: cfg?.enabled ?? true

    readonly property bool onTop: cfg?.onTop ?? false

    readonly property int height: cfg?.height ?? 30
    readonly property int margins: cfg?.margins ?? 15
    readonly property int borderWidth: cfg?.borderWidth ?? 3

    readonly property int radius: cfg?.radius ?? 12
    readonly property int innerRadius: cfg?.innerRadius ?? 24

    readonly property int spacing: cfg?.spacing ?? 10
    readonly property int longSpacing: cfg?.longSpacing ?? 4

    readonly property real clockScale: cfg?.clockScale ?? 0.95
    readonly property real layoutScale: cfg?.layoutScale ?? 0.75
    readonly property real iconScale: cfg?.iconScale ?? 0.6
    readonly property real activeWindowScale: cfg?.activeWindowScale ?? 0.8

    readonly property int activeWindowWidth: cfg?.activeWindowWidth ?? 750
}
