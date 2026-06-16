# Editor
if command -v nvim &>/dev/null; then
    alias_expandable -g 'v=nvim'
else
    alias_expandable -g v=vim
fi

# Eza
if ommand -v eza &>/dev/null; then
    alias -g ls='eza --color=auto --icons=always --git --no-user'
else
    alias -g ls='ls --color=auto -h'
fi

# Bat
if command -v bat &>/dev/null; then
    alias cat='bat'
    alias -- --help='--help 2>&1 | bat --language=help --style=plain'
elif command -v batcat &>/dev/null; then
    alias cat='batcat'
    alias -- --help='--help 2>&1 | batcat --language=help --style=plain'
fi
alias printkey='\cat -v'

# Tree for stdin
alias as-tree='tree --fromfile'

# Config actions
alias cfg-edit='chezmoi edit'

# Clipboard
if [[ $OSTYPE = "linux-gnu" ]]; then
    alias -g cb-copy='wl-copy || xclip -in -selection clipboard'
    alias -g cb-paste='wl-paste'
fi

alias mv="mv -i"
alias cp="cp -ri"
alias mkdir="mkdir -p"
alias c=' clear && tmux clear-history || true'

alias path='echo -e ${PATH//:/\\n}'

alias ping='ping -c 5'

alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'

alias s='env -u TERMINFO sudo'
