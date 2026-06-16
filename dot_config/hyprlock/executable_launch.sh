#!/usr/bin/env sh

mode=$1
inputpath="$XDG_CACHE_HOME/wm/wallpaper.jpg"
savepath="$XDG_CACHE_HOME/wm/lockscreen_wallpaper.jpg"

lock_path="$(dirname "$0")/"

function create_bg_from_wallpaper() {
    mkdir -p "$(dirname "$2")"
    [[ $1 -nt $2 ]] && ffmpeg -i "$1" -vf "
        scale=iw/4:ih/4:flags=neighbor,
        scale=iw*4:ih*4:flags=neighbor,
        gblur=sigma=2,
        eq=brightness=-0.3:contrast=1.5,
        vignette='PI/5',
        noise=alls=20:allf=t+u,
        format=yuv420p
      " -q:v 1 -y "$2"
}

function update_assets() {
    create_bg_from_wallpaper "$inputpath" "$savepath"
    "$lock_path/generate_clock.py"
}

update_assets

pidof hyprlock || hyprlock -c "$lock_path/hyprlock.conf"
