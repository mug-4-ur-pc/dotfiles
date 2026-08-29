
import Quickshell.Io

JsonObject {
    id: menu
    required property var cfg

    readonly property int height: cfg?.height ?? 90
    readonly property int width: cfg?.width ?? 450
    readonly property int searchWidth: cfg?.searchWidth ?? 400
    readonly property int nRows: cfg?.nRows ?? 4
    readonly property int nColumns: cfg?.nColumns ?? 2
    readonly property int radius: cfg?.radius ?? 20
    readonly property int spacing: cfg?.spacing ?? 30
    readonly property int margins: cfg?.margins ?? 5
    readonly property real opacity: cfg?.opacity ?? 0.7
}
