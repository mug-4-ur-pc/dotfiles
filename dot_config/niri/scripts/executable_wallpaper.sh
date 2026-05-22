#!/usr/bin/env sh

killall awww 2>/dev/null
killall hyprpaper 2>/dev/null
killall swaybg 2>/dev/null

wallpaper=$XDG_WALLPAPERS_DIR/default.jpg

swaybg -m fill -i $wallpaper &
