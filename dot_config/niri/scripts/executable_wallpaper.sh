#!/usr/bin/env sh

wallpaper=$XDG_WALLPAPERS_DIR/default.jpg

if [[ $1 != "" ]]; then
    ffmpeg -i $1 -q:v 1 -y $wallpaper
fi

niri msg action do-screen-transition --delay-ms 500

killall awww 2>/dev/null
killall hyprpaper 2>/dev/null
killall swaybg 2>/dev/null

swaybg -m fill -i $wallpaper &
