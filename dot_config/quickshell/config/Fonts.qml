
import Quickshell.Io

import qs.services

JsonObject {
    id: fonts
    default property var cfg: {{}}

    readonly property string mono:      cfg?.mono    ?? Chezmoi.data.font.mono
    readonly property string propo:     cfg?.propo   ?? Chezmoi.data.font.propo
    readonly property string regular:   cfg?.regular ?? Chezmoi.data.font.regular
    readonly property string serif:     cfg?.serif   ?? Chezmoi.data.font.serif
    readonly property string sans:      cfg?.sans    ?? Chezmoi.data.font.sans

    readonly property JsonObject size: JsonObject {
        readonly property int xs:  cfg?.sizeXS  ?? Chezmoi.data.font.size.XS
        readonly property int s:   cfg?.sizeS   ?? Chezmoi.data.font.size.S
        readonly property int m:   cfg?.sizeM   ?? Chezmoi.data.font.size.M
        readonly property int l:   cfg?.sizeL   ?? Chezmoi.data.font.size.L
        readonly property int xl:  cfg?.sizeXL  ?? Chezmoi.data.font.size.XL
        readonly property int xxl: cfg?.sizeXXL ?? Chezmoi.data.font.size.XXL
    }
}
