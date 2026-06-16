
import Quickshell.Io

import QtQuick
import qs.services

JsonObject {
    id: theme
    default property var cfg: {{}}

    readonly property string name:   cfg?.name   ?? Chezmoi.data.theme.name
    readonly property bool   isDark: cfg?.isDark ?? Chezmoi.data.theme.is_dark

    readonly property string iconTheme: cfg?.iconTheme ?? Chezmoi.data.theme.icons

    readonly property color background: cfg?.background ?? Chezmoi.getColor("background")
    readonly property color foreground: cfg?.background ?? Chezmoi.getColor("foreground")

    readonly property color primary:            cfg?.primary            ?? Chezmoi.getColor("primary")
    readonly property color primaryFg:          cfg?.primaryFg          ?? Chezmoi.getColor("primary_fg")
    readonly property color primaryContainer:   cfg?.primaryContainer   ?? Chezmoi.getColor("primary_container")
    readonly property color primaryContainerFg: cfg?.primaryContainerFg ?? Chezmoi.getColor("primary_container_fg")

    readonly property color secondary:              cfg?.secondary            ?? Chezmoi.getColor("secondary")
    readonly property color secondaryFg:            cfg?.secondaryFg          ?? Chezmoi.getColor("secondary_fg")
    readonly property color secondaryContainer:     cfg?.secondaryContainer   ?? Chezmoi.getColor("secondary_container")
    readonly property color secondaryContainerFg:   cfg?.secondaryContainerFg ?? Chezmoi.getColor("secondary_container_fg")

    readonly property color tertiary:               cfg?.tertiary            ?? Chezmoi.getColor("tertiary")
    readonly property color tertiaryFg:             cfg?.tertiaryFg          ?? Chezmoi.getColor("tertiary_fg")
    readonly property color tertiaryContainer:      cfg?.tertiaryContainer   ?? Chezmoi.getColor("tertiary_container")
    readonly property color tertiaryContainerFg:    cfg?.tertiaryContainerFg ?? Chezmoi.getColor("tertiary_container_fg")

    readonly property color error:              cfg?.error            ?? Chezmoi.getColor("error")
    readonly property color errorFg:            cfg?.errorFg          ?? Chezmoi.getColor("error_fg")
    readonly property color errorContainer:     cfg?.errorContainer   ?? Chezmoi.getColor("error_container")
    readonly property color errorContainerFg:   cfg?.errorContainerFg ?? Chezmoi.getColor("error_container_fg")

    readonly property color surface:            cfg?.surface          ?? Chezmoi.getColor("surface")
    readonly property color surfaceFg:          cfg?.surfaceFg        ?? Chezmoi.getColor("surface_fg")
    readonly property color surfaceVariant:     cfg?.surfaceVariant   ?? Chezmoi.getColor("surface_variant")
    readonly property color surfaceVariantFg:   cfg?.surfaceVariantFg ?? Chezmoi.getColor("surface_variant_fg")

    readonly property color inverseSurface:     cfg?.inverseSurface   ?? Chezmoi.getColor("inverse_surface")
    readonly property color inverseSurfaceFg:   cfg?.inverseSurfaceFg ?? Chezmoi.getColor("inverse_surface_fg")
    readonly property color inversePrimary:     cfg?.inversePrimary   ?? Chezmoi.getColor("inverse_primary")

    readonly property color outline:        cfg?.outline        ?? Chezmoi.getColor("outline")
    readonly property color outlineVariant: cfg?.outlineVariant ?? Chezmoi.getColor("outline_variant")
    readonly property color shadow:         cfg?.shadow         ?? Chezmoi.getColor("shadow_argb")
    readonly property color scrim:          cfg?.scrim          ?? Chezmoi.getColor("scrim")

    readonly property color black:      cfg?.black      ?? Chezmoi.getColor("black")
    readonly property color red:        cfg?.red        ?? Chezmoi.getColor("red")
    readonly property color green:      cfg?.green      ?? Chezmoi.getColor("green")
    readonly property color yellow:     cfg?.yellow     ?? Chezmoi.getColor("yellow")
    readonly property color blue:       cfg?.blue       ?? Chezmoi.getColor("blue")
    readonly property color magenta:    cfg?.magenta    ?? Chezmoi.getColor("magenta")
    readonly property color cyan:       cfg?.cyan       ?? Chezmoi.getColor("cyan")
    readonly property color lightgray:  cfg?.lightgray  ?? Chezmoi.getColor("lightgray")

    readonly property color darkgray:       cfg?.darkgray       ?? Chezmoi.getColor("darkgray")
    readonly property color brightred:      cfg?.brightred      ?? Chezmoi.getColor("brightred")
    readonly property color brightgreen:    cfg?.brightgreen    ?? Chezmoi.getColor("brightgreen")
    readonly property color brightyellow:   cfg?.brightyellow   ?? Chezmoi.getColor("brightyellow")
    readonly property color brightblue:     cfg?.brightblue     ?? Chezmoi.getColor("brightblue")
    readonly property color brightmagenta:  cfg?.brightmagenta  ?? Chezmoi.getColor("brightmagenta")
    readonly property color brightcyan:     cfg?.brightcyan     ?? Chezmoi.getColor("brightcyan")
    readonly property color white:          cfg?.white          ?? Chezmoi.getColor("white")
}
