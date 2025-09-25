#####################################
##==> Variables
#####################################

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

#####################################
##==> Aliases
#####################################

# Windows Development Aliases
alias github="cd ~/Github"

# Github alias
alias python="python3"

# Quick Navigation
alias home="cd ~"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# File Operations
alias ll="ls -la"
alias la="ls -la"
alias l="ls -l"
alias cls="clear"

# Git Shortcuts
alias gs="git status"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit"
alias gcm="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gco="git checkout"
alias gb="git branch"
alias gd="git diff"
alias glog="git log --oneline --graph --decorate"

# Node.js/NPM Shortcuts
alias ni="npm install"
alias ns="npm start"
alias nt="npm test"
alias nb="npm run build"
alias nd="npm run dev"
alias nrd="npm run dev"
alias nrs="npm run start"
alias nrt="npm run test"
alias nrb="npm run build"

# Yarn Shortcuts
alias ys="yarn start"
alias yi="yarn install"
alias yt="yarn test"
alias yb="yarn build"
alias yd="yarn dev"

# System Utils
alias reload="source ~/.config/fish/config.fish"
alias editrc="code ~/.config/fish/config.fish"
alias editfish="code ~/.config/fish/config.fish"

# Docker Shortcuts
alias dc="docker-compose" 
alias dcu="docker-compose up"
alias dcd="docker-compose down"
alias dcb="docker-compose build"
alias dps="docker ps"
alias di="docker images"

# VS Code Shortcuts
alias code="code ."
alias cursor="cursor ."
alias codeh="code ~"
alias cursorh="cursor ~"

#####################################
##==> Custom Functions
#####################################
function mkcd
    mkdir -p $argv[1]
    cd $argv[1]
end

function take
    mkdir -p $argv[1]
    cd $argv[1]
end

function ginit
    git init
    git add .
    git commit -m "feat: initial commit"
end

function gclone
    git clone "git@github.com:phamhuulocforwork/$argv[1].git"
    if test (count $argv) -ge 2
        cd "$argv[2]"
    else
        cd "$argv[1]"
    end
end

function mclone
    set file "$argv[1]"

    if test -z "$file" -o ! -f "$file"
        echo "Usage: mclone <file_with_repo_urls>"
        return 1
    end

    set repos
    while read -l line
        set line (echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        if test -n "$line" -a (string match -v -r '^#' "$line")
            set repos $repos "$line"
        end
    end < "$file"

    set n (count $repos)
    if test $n -eq 0
        echo "File does not have a valid repo"
        return 1
    end

    echo "Cloning $n repos in parallel..."

    if command -v parallel >/dev/null 2>&1
        printf "%s\n" $repos | parallel -j "$n" 'git clone "{}"'
    else
        for repo in $repos
            git clone "$repo" &
        end
        wait
    end
end

function clone
    git clone "$argv[1]"
    if test (count $argv) -ge 2
        cd "$argv[2]"
    else
        cd (basename "$argv[1]" .git)
    end
end

function system-clean
    echo "Cleaning temp files in /tmp and /var/tmp..."
    sudo rm -rf /tmp/* /var/tmp/*

    echo "Cleaning apt cache..."
    if command -v apt-get >/dev/null 2>&1
        sudo apt-get clean -y
        sudo apt-get autoclean -y
        sudo apt-get autoremove -y
    end

    echo "Cleaning pip, npm, and user cache..."
    rm -rf ~/.cache/pip ~/.npm ~/.cache/* ~/.local/share/*Trash*/files/*

    echo "Cleaning old logs..."
    sudo journalctl --vacuum-time=7d
    sudo rm -rf /var/log/*.gz /var/log/*.[0-9]

    echo "Done!"
end

function venv-clean
    echo "Deleting 'venv' folders..."
    find . -type d -name "venv" -exec rm -rf {} +
    echo "Done"
end

function npkill
    echo "Deleting 'node_modules' ..."
    find . -type d -name "node_modules" -exec rm -rf {} +
    echo "Done"
end

function ssh-setup
    echo -e "Generating SSH key..."

    set SSH_KEY "$HOME/.ssh/id_ed25519"
    if test ! -f "$SSH_KEY"
        mkdir -p "$HOME/.ssh"
        ssh-keygen -t ed25519 -C "phamhuulocforwork@gmail.com" -f "$SSH_KEY" -N "PhamHuuLoc"
        echo -e "SSH key generated at $SSH_KEY "
    else
        echo -e "SSH key already exists at $SSH_KEY "
    end

    if command -v wl-copy >/dev/null 2>&1
        cat "$SSH_KEY.pub" | wl-copy
        echo -e "SSH public key copied to clipboard (Wayland) "
    else if command -v xclip >/dev/null 2>&1
        cat "$SSH_KEY.pub" | xclip -selection clipboard
        echo -e "SSH public key copied to clipboard (X11) "
    else
        echo -e "Neither wl-copy nor xclip found. Please install one to copy SSH key to clipboard. "
        echo -e "You can still get your key with: cat $SSH_KEY.pub "
    end
end

#####################################
##==> Shell Customization
#####################################

if test "$PWD" = "$HOME"
    fastfetch
    cd ~/Github
end

# Oh My Posh initialization
if command -q oh-my-posh
    oh-my-posh init fish --config ~/.config/ohmyposh/theme.omp.json | source
end
