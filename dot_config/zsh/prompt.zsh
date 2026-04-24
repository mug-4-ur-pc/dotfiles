autoload -U colors && colors
setopt prompt_subst

typeset -g PROMPT_EXIT_CODE=0

function precmd() {
    PROMPT_EXIT_CODE=$?
}

function prompt_exit_code() {
    local code=$PROMPT_EXIT_CODE
    (( code != 0 )) && echo "%F{red}${code}%f "
}

function prompt_char() {
    if [[ $PROMPT_EXIT_CODE = 0 ]]; then
        echo "%F{green}:)%f"
    else
        echo "%F{red}:(%f"
    fi
}

function prompt_pwd() {
    local pwd="${PWD/#$HOME/~}"
    # If in git repo, show repo name + relative path
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local repo=$(basename "$(git rev-parse --show-toplevel)")
        local rel=$(git rev-parse --show-prefix)
        echo "%F{magenta}$repo%f/%F{cyan}${rel%/}%f"
    else
        # Shorten deep paths: ~/p/project instead of ~/projects/project
        echo "%F{magenta}${pwd:s/~/\~/}%f"
    fi
}

function prompt_git() {
    git rev-parse --is-inside-work-tree &>/dev/null || return

    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD)
    local has_staged=$(git diff --cached --quiet 2>/dev/null; echo $?)
    local has_unstaged=$(git diff --quiet 2>/dev/null; echo $?)

    local color="%F{darkgray}"  # default: clean

    if [[ $has_staged -ne 0 && $has_unstaged -eq 0 ]]; then
        color="%F{green}"      # only staged
    elif [[ $has_staged -eq 0 && $has_unstaged -ne 0 ]]; then
        color="%F{magenta}"    # only unstaged
    elif [[ $has_staged -ne 0 && $has_unstaged -ne 0 ]]; then
        color="%F{yellow}"     # both (mixed) - or keep magenta
    fi

    echo " %B${color}${branch}%f%b=>"
}

PROMPT=' $(prompt_git)$(prompt_pwd) $(prompt_exit_code)$(prompt_char) '
