#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Export environment variables
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS=-R

# Add user bin to PATH
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    export PATH="$HOME/bin:$PATH"
fi

# Aliases
alias ls='lsd'
alias ll='lsd -la'
alias la='lsd -A'
alias l='lsd -l'
alias grep='grep --color=auto'
alias cat='bat'
alias vim='nvim'
alias vi='nvim'
alias nano='nvim'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcl='git clone'

# Useful functions
mkcd() {
    mkdir -p "$1"
    cd "$1"
}

take() {
    mkdir -p "$1"
    cd "$1"
}

# Display fastfetch on terminal start
if command -q fastfetch; then
    fastfetch
fi