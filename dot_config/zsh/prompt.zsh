autoload -U colors && colors
setopt prompt_subst

typeset -g PROMPT_EXIT_CODE=0
typeset -g PROMPT_GIT_INFO=""
typeset -g PROMPT_PWD_INFO=""
typeset -g PROMPT_EXIT_INFO=""
typeset -g PROMPT_CHAR=""

function precmd() {
    PROMPT_EXIT_CODE=$?

    # Pre-compute exit code display
    if ((PROMPT_EXIT_CODE != 0)); then
        PROMPT_EXIT_INFO="%F{red}${PROMPT_EXIT_CODE}%f "
    else
        PROMPT_EXIT_INFO=""
    fi

    # Pre-compute prompt character
    if [[ $PROMPT_EXIT_CODE == 0 ]]; then
        PROMPT_CHAR="%F{green}:)%f"
    else
        PROMPT_CHAR="%F{red}:(%f"
    fi

    # Pre-compute git and pwd info (the expensive part)
    local git_toplevel
    if git_toplevel=$(git rev-parse --show-toplevel 2>/dev/null); then
        local repo=$(basename "$git_toplevel")
        local prefix=$(git rev-parse --show-prefix 2>/dev/null)
        PROMPT_PWD_INFO="%F{magenta}${repo}%f/%F{cyan}${prefix%/}%f"

        local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
        git diff --cached --quiet 2>/dev/null
        local has_staged=$?
        git diff --quiet 2>/dev/null
        local has_unstaged=$?

        local color="%F{darkgray}"
        if [[ $has_staged -ne 0 && $has_unstaged -eq 0 ]]; then
            color="%F{green}"
        elif [[ $has_staged -eq 0 && $has_unstaged -ne 0 ]]; then
            color="%F{magenta}"
        elif [[ $has_staged -ne 0 && $has_unstaged -ne 0 ]]; then
            color="%F{yellow}"
        fi

        PROMPT_GIT_INFO=" %B${color}${branch}%f%b=>"
    else
        local pwd="${PWD/#$HOME/~}"
        PROMPT_PWD_INFO="%F{magenta}${pwd}%f"
        PROMPT_GIT_INFO=""
    fi
}

PROMPT=' ${PROMPT_GIT_INFO}${PROMPT_PWD_INFO} ${PROMPT_EXIT_INFO}${PROMPT_CHAR} '
