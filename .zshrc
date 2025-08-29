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
export PATH="$HOME/.local/bin:$PATH"

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

function mclone() {
  local file="$1"

  if [[ -z "$file" || ! -f "$file" ]]; then
    echo "Usage: mclone <file_with_repo_urls>"
    return 1
  fi

  local repos=()
  while IFS= read -r line; do
    line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    repos+=("$line")
  done < "$file"

  local n=${#repos[@]}
  if [[ $n -eq 0 ]]; then
    echo "File does not have a valid repo"
    return 1
  fi

  echo "Cloning $n repos in parallel..."

  if command -v parallel >/dev/null 2>&1; then
    printf "%s\n" "${repos[@]}" | parallel -j "$n" 'git clone "{}"'
  else
    for repo in "${repos[@]}"; do
      git clone "$repo" &
    done
    wait
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
