#!/usr/bin/env sh

lock="$XDG_CONFIG_HOME/hyprlock/launch.sh"

killall swayidle

if command -v acpi; then
    swayidle -w \
        timeout 300 'brightnessctl --class=backlight -e set -50%' \
        resume 'brightnessctl --class=backlight -r' \
        timeout 450 'loginctl lock-session' \
        timeout 600 'niri msg action power-off-monitors' \
        resume "niri msg action power-on-monitors" \
        timeout 900 'systemctl suspend' \
        before-sleep "$lock" \
        after-resume "niri msg action power-on-monitors" \
        lock "$lock" &
else
    swayidle -w \
        timeout 450 'loginctl lock-session' \
        timeout 600 'niri msg action power-off-monitors' \
        resume "niri msg action power-on-monitors" \
        before-sleep "$lock" \
        after-resume "niri msg action power-on-monitors" \
        lock "$lock" &
fi
