pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    CustomLoader { id: custom }

    readonly property JsonObject bar:   BarConfig   { cfg: custom.json?.bar ?? {} }
    readonly property JsonObject theme: Theme       { cfg: custom.json?.theme ?? {} }
    readonly property JsonObject font:  Fonts       { cfg: custom.json?.fonts ?? {} }
}
