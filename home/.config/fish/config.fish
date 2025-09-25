# Fish shell configuration for WSL Ubuntu

# Set environment variables
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx LESS -R

# Add user bin to PATH
if not contains $HOME/bin $PATH
    set -gx PATH $HOME/bin $PATH
end

# Configure fzf
if functions -q fzf
    fzf --fish | source
end

# Aliases
alias ls="lsd"
alias ll="lsd -la"
alias la="lsd -A"
alias l="lsd -l"
alias tree="lsd --tree"
alias grep="grep --color=auto"
alias cat="bat"
alias vim="nvim"
alias vi="nvim"
alias nano="nvim"

# Git aliases
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline"
alias gd="git diff"
alias gb="git branch"
alias gco="git checkout"
alias gcl="git clone"

# Useful functions
function mkcd
    mkdir -p $argv[1]
    cd $argv[1]
end

function take
    mkdir -p $argv[1]
    cd $argv[1]
end

# Fastfetch greeting
if command -q fastfetch
    fastfetch
end

# Oh My Posh initialization
if command -q oh-my-posh
    oh-my-posh init fish --config ~/.config/ohmyposh/theme.omp.json | source
end
