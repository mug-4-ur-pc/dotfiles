
import Quickshell.Io

JsonObject {
    id: bar
    default property var cfg: {{}}

    readonly property int radius: cfg?.radius ?? 8
}
