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

