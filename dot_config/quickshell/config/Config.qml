pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    CustomLoader { id: custom }

    readonly property JsonObject bar:       BarConfig    { cfg: custom.json?.bar ?? {} }
    readonly property JsonObject popups:    PopupsConfig { cfg: custom.json?.popups ?? {} }
    readonly property JsonObject font:      Fonts        { cfg: custom.json?.fonts ?? {} }
    readonly property JsonObject theme:     Theme        { cfg: custom.json?.theme ?? {} }
    readonly property JsonObject wallpaper: Wallpaper    { cfg: custom.json?.wallpaper ?? {} }
    readonly property JsonObject idle:      IdleConfig   { cfg: custom.json?.idle ?? {} }
    readonly property JsonObject misc:      IdleConfig   { cfg: custom.json?.misc ?? {} }
}
