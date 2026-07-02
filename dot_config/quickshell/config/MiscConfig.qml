
import Quickshell.Io

JsonObject {
    id: misc
    required property var cfg

    readonly property string mainScreenName: cfg?.mainScreenName ?? ""
}
