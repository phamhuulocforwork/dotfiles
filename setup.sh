#!/usr/bin/env bash
set -euo pipefail

clear

echo -e "${BLUE}"
cat <<"EOF"
███████╗███████╗████████╗██╗   ██╗██████╗
██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
███████╗█████╗     ██║   ██║   ██║██████╔╝
╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝
███████║███████╗   ██║   ╚██████╔╝██║
╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝
EOF
echo -e "${NC}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

MODULES=(git zsh .config)

if ! grep -qi "arch" /etc/os-release; then
    echo -e "${YELLOW}Warning: This script is designed for Hyprland on an Arch-based system${NC}"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

cd ~

echo -e "${BLUE}Updating system packages...${NC}"
sudo pacman -Syu --noconfirm

if ! command -v yay &> /dev/null; then
    echo -e "${BLUE}Setup yay...${NC}"
    sudo pacman -S --noconfirm --needed base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf ~/yay
else
    echo -e "${GREEN}yay is already installed.${NC}"
fi

echo -e "${BLUE}Setting locale...${NC}"
sudo sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
sudo locale-gen
sudo localectl set-locale LANG=en_US.UTF-8

echo -e "${BLUE}==> Setting up terminal environment...${NC}"
if [[ -f ~/dotfiles/terminal.sh ]]; then
    bash ~/dotfiles/terminal.sh
    echo -e "${GREEN}==> Terminal setup completed.${NC}"
else
    echo -e "${RED}Error: terminal.sh not found in dotfiles directory.${NC}"
    exit 1
fi

echo -e "${BLUE}Creating Github directory...${NC}"
if [ ! -d ~/Github ]; then
    mkdir ~/Github
    echo -e "${GREEN}Github directory created${NC}"
fi

echo -e "${BLUE}Copying dotfiles to home directory...${NC}"
cd ~

# Backup existing dotfiles that might conflict
echo -e "${YELLOW}Backing up existing dotfiles that might conflict...${NC}"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# List of files/directories that will be stowed
DOTFILES_TO_CHECK=(
    ".gitconfig"
    ".zshrc"
    ".zsh_aliases"
)

for file in "${DOTFILES_TO_CHECK[@]}"; do
    if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
        echo -e "${YELLOW}Backing up existing $file to $BACKUP_DIR/${NC}"
        mv "$HOME/$file" "$BACKUP_DIR/"
    elif [ -L "$HOME/$file" ]; then
        echo -e "${BLUE}Removing existing symlink $file${NC}"
        rm "$HOME/$file"
    fi
done

cd ~/dotfiles

for module in "${MODULES[@]}"; do
    echo "Linking $module..."
    stow -R "$module"
done

echo -e "${GREEN}Dotfiles backup saved to: $BACKUP_DIR${NC}"

echo -e "${BLUE}==> Generating SSH key...${NC}"

SSH_KEY="$HOME/.ssh/id_ed25519"
if [ ! -f "$SSH_KEY" ]; then
    mkdir -p "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "phamhuulocforwork@gmail.com" -f "$SSH_KEY" -N ""
    echo -e "${GREEN}SSH key generated at $SSH_KEY${NC}"
else
    echo -e "${YELLOW}SSH key already exists at $SSH_KEY${NC}"
fi

# Copy SSH public key to clipboard (requires xclip or wl-clipboard)
if command -v wl-copy &>/dev/null; then
    cat "$SSH_KEY.pub" | wl-copy
    echo -e "${GREEN}SSH public key copied to clipboard (Wayland)${NC}"
elif command -v xclip &>/dev/null; then
    cat "$SSH_KEY.pub" | xclip -selection clipboard
    echo -e "${GREEN}SSH public key copied to clipboard (X11)${NC}"
else
    echo -e "${YELLOW}Neither wl-copy nor xclip found. Please install one to copy SSH key to clipboard.${NC}"
    echo -e "${YELLOW}You can still get your key with: cat $SSH_KEY.pub${NC}"
fi

echo
echo "*********************************************************************"
echo "*                    Hyprland setup is complete!                    *"
echo "*                                                                   *"
echo "*   It is recommended to REBOOT your system to apply all changes.   *"
echo "*                                                                   *"
echo "*                 Have a great time with Hyprland!!                 *"
echo "*********************************************************************"
echo