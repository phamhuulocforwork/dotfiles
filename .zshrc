export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="catppuccin"
CATPPUCCIN_FLAVOR="mocha"
CATPPUCCIN_SHOW_TIME=false

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    docker-compose
    npm
    node
    vscode
    github
)

source $ZSH/oh-my-zsh.sh

export PATH="/mnt/c/Program Files/Microsoft VS Code/bin:$PATH"
export PATH="/mnt/c/Users/PC/AppData/Roaming/npm:$PATH"

if [[ "$PWD" == "$HOME" ]]; then
    cd ~/Github
fi

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

function gcloneb() {
  local file="$1"
  local dest="${2:-cloned_repos}"

  if [[ ! -f "$file" ]]; then
    echo "File not found."
    return 1
  fi

  mkdir -p "$dest"

  while IFS= read -r repo; do
    if [[ -z "$repo" || "$repo" == \#* ]]; then
      continue
    fi

    echo "Cloning $repo ..."
    git clone "$repo" "$dest/$(basename -s .git "$repo")"
  done < "$file"
}

function clone() {
    git clone "$1"
    if [ "$2" ]; then
        cd "$2"
    else
        cd "$(basename "$1" .git)"
    fi
}

venv_list() {
  echo "List of 'venv' directories to be deleted:"
  find . -type d -name "venv"
}

venv_clean() {
  echo "Deleting 'venv' folders..."
  find . -type d -name "venv" -exec rm -rf {} +
  echo "Done"
}

npkill() {
  echo "Deleting 'node_modules' ..."
  find . -type d -name "node_modules" -exec rm -rf {} +
  echo "Done"
}

if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi

export EDITOR="code"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
