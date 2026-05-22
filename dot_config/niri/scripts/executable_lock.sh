#!/usr/bin/env sh

mode=$1

if [[ "$mode" == "off" ]]; then
    niri msg action power-off-monitors
fi

pidof hyprlock || hyprlock
