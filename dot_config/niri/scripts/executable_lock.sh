#!/usr/bin/env sh

mode=$1
inputpath=$XDG_WALLPAPERS_DIR/default.jpg
savepath=$XDG_CACHE_HOME/wm/lockscreen_wallpaper.jpg

function create_bg_from_screenshot() {
    mkdir -p "$(dirname "$1")"
    tmp=/tmp/screenshot.jpg
    grim "$tmp"
    ffmpeg -i "$tmp" -vf "
        scale=iw/4:ih/4:flags=neighbor,
        scale=iw*4:ih*4:flags=neighbor,
        gblur=sigma=2,
        eq=brightness=-0.3:contrast=1.5,
        vignette='PI/5',
        noise=alls=20:allf=t+u,
        format=yuv420p
      " -q:v 1 -y "$1"
    rm "$tmp"
}

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
    create_bg_from_wallpaper $inputpath $savepath
    $XDG_CONFIG_HOME/niri/scripts/lock/clock.py
}

update_assets

if [[ "$mode" == "off" ]]; then
    niri msg action power-off-monitors
fi

pidof hyprlock || hyprlock -c $XDG_CONFIG_HOME/niri/scripts/lock/hyprlock.conf
