# Oh My Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="catppuccin"
CATPPUCCIN_FLAVOR="mocha"
CATPPUCCIN_SHOW_TIME=false

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    docker-compose
    npm
    node
    yarn
    vscode
    github
)

# Source Catppuccin theme for zsh-syntax-highlighting BEFORE Oh My Zsh is sourced
source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Windows Path Integration
export PATH="/mnt/c/Program Files/Microsoft VS Code/bin:$PATH"
export PATH="/mnt/c/Users/PC/AppData/Roaming/npm:$PATH"

# Auto cd to projects directory on startup
if [[ "$PWD" == "$HOME" ]]; then
    cd ~/Github
fi

# Custom Functions
function mkcd() {
    mkdir -p "$1" && cd "$1"
}

function ginit() {
    git init
    git add .
    git commit -m "feat: initial commit"
}

function gclone() {
    git clone "git@github.com:phamhuulocforwork/$1.git"
    if [ "$2" ]; then
        cd "$2"
    else
        cd "$1"
    fi
}

function clone() {
    git clone "$1"
    if [ "$2" ]; then
        cd "$2"
    else
        cd "$(basename "$1" .git)"
    fi
}

# Load custom aliases
if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi

export EDITOR="code"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
