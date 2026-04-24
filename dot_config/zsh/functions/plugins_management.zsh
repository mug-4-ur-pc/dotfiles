#!/usr/bin/env zsh


function plugin-load {
    local plugin repo commitsha plugdir initfile initfiles=() clone_args=()
    for plugin in $@; do
        repo="$plugin"
        clone_args=(--quiet --depth 1 --recursive --shallow-submodules)
        commitsha=""
        # Pin repo to a specific commit sha if provided
        if [[ "$plugin" == *'@'* ]]; then
            repo="${plugin%@*}"
            commitsha="${plugin#*@}"
            clone_args+=(--no-checkout)
        fi
        plugdir=$_zplugindir/${repo:t}
        initfile=$plugdir/${repo:t}.plugin.zsh
        if [[ ! -d $plugdir ]]; then
            echo "Cloning $repo..."
            git clone "${clone_args[@]}" https://github.com/$repo $plugdir
            if [[ -n "$commitsha" ]]; then
                git -C $plugdir fetch -q origin "$commitsha"
                git -C $plugdir checkout -q "$commitsha"
            fi
        fi
        if [[ ! -e $initfile ]]; then
            initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
            (( $#initfiles )) || { echo >&2 "No init file found '$repo'." && continue }
            ln -sf $initfiles[1] $initfile
        fi
        fpath+=$plugdir
        (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
    done
}


function plugin-compile {
    autoload -U zrecompile
    local f
    for f in $_zplugindir/**/*.zsh{,-theme}(N); do
        zrecompile -pq "$f"
    done
}


function plugin-update {
    local update_interval=$1
    local min_time_diff=$(( 24 * 60 * 60 * update_interval ))
    local current_time=$(date +%s)
    local time_file=$_zplugindir/last_update_secs.tmp

    local last_time=$(cat $time_file 2> /dev/null || echo 0)
    local time_diff=$(( current_time - last_time ))

    if (( time_diff >= min_time_diff )); then
        rm -rf $_zplugindir 2>/dev/null
        mkdir -p $_zplugindir
        echo $current_time > $time_file
        echo 'Updating ZSH plugins...'
    fi
}


function fast-theme-generate() {
    mkdir -p $FAST_WORK_DIR
    if [[ ! -f $FAST_WORK_DIR/current_theme.zsh.zwc || $1 = '-f' || $1 = '--force' ]]; then
        fast-theme $ZDOTDIR/fast_theme.ini
    fi
}
