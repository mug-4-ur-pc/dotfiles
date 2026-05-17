#!/usr/bin/env zsh

function expand-alias() {
    if _is_alias_expandable; then
        zle _expand_alias
    fi
    zle self-insert
}

function _is_alias_expandable() {
    local last_word=${LBUFFER%% #}
    last_word=${last_word#* }
    [[ -n $EXPANDABLE_ALIASES[$last_word] ]]
}

typeset -gA EXPANDABLE_ALIASES
function alias_expandable() {
    alias $@
    for arg in $@; do
        if [[ $arg != -* ]]; then
            local name=${arg%%=*}
            EXPANDABLE_ALIASES[$name]=1
        fi
    done
}

function _hex_to_sh_rgb() {
    local hex="$1"

    # Strip leading # if present
    hex="${hex#\#}"

    # Validate
    if [[ "$hex" != [0-9a-fA-F](#c6) ]]; then
        echo "Error: invalid hex color '$1'" >&2
        return 1
    fi

    # Convert hex to decimal
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))

    echo "${r};${g};${b}"
}
