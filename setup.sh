#!/usr/bin/env bash
set -e

# ===========================
# Color-coded status labels
# ===========================
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
WARN="$(tput setaf 3)[WARN]$(tput sgr0)"
OK="$(tput setaf 2)[OK]$(tput sgr0)"
NOTE="$(tput setaf 6)[NOTE]$(tput sgr0)"
ACTION="$(tput setaf 5)[ACTION]$(tput sgr0)"
RESET="$(tput sgr0)"
CYAN="$(tput setaf 6)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"

# ===========================
# Log Details
# ===========================
mkdir -p "$HOME/dotfiles_log"
LOG_FILE="$HOME/dotfiles_log/install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# ==========================
# Initial Bannar
# =========================
clear
echo -e "\n"
echo -e "${CYAN}     ███████╗███████╗████████╗██╗   ██╗██████╗ ${RESET}"
echo -e "${CYAN}     ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗${RESET}"
echo -e "${CYAN}     ███████╗█████╗     ██║   ██║   ██║██████╔╝${RESET}"
echo -e "${CYAN}     ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ ${RESET}"
echo -e "${CYAN}     ███████║███████╗   ██║   ╚██████╔╝██║     ${RESET}"
echo -e "${CYAN}     ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ${RESET}"
echo -e "${RED}     ✻───────────────phamhuuloc───────────────✻${RESET}"
echo -e "${GREEN}     Welcome to dotfiles! lets begin setup 👋 ${RESET}"
echo -e "\n"

# ===========================
# Define script directory
# ===========================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# ===========================
# Ask for sudo once, keep it alive
# ===========================
echo "${NOTE} Asking for sudo password^^...${RESET}"
sudo -v

keep_sudo_alive() {
  while true; do
    sudo -n true
    sleep 30
  done
}
keep_sudo_alive &
SUDO_KEEP_ALIVE_PID=$!
trap 'kill $SUDO_KEEP_ALIVE_PID' EXIT

# ===========================
# Define modules to be stowed
# ===========================
MODULES=(git zsh .config)

if ! grep -qi "arch" /etc/os-release; then
    echo -e "${YELLOW}Warning: This script is designed for Hyprland on an Arch-based system${NC}"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# ===========================
# Update system packages
# ===========================
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

# ===========================
# Set locale
# ===========================
echo -e "${BLUE}Setting locale...${NC}"
sudo sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
sudo locale-gen
sudo localectl set-locale LANG=en_US.UTF-8

# ===========================
# Set up terminal environment
# ===========================
echo -e "${BLUE}==> Setting up terminal environment...${NC}"
if [[ -f ~/dotfiles/terminal.sh ]]; then
    bash ~/dotfiles/terminal.sh
    echo -e "${GREEN}==> Terminal setup completed.${NC}"
else
    echo -e "${RED}Error: terminal.sh not found in dotfiles directory.${NC}"
    exit 1
fi

# ===========================
# Create Github directory
# ===========================
echo -e "${BLUE}Creating Github directory...${NC}"
if [ ! -d ~/Github ]; then
    mkdir ~/Github
    echo -e "${GREEN}Github directory created${NC}"
fi

# ===========================
# Copy dotfiles to home directory
# ===========================
echo -e "${BLUE}Copying dotfiles to home directory...${NC}"
cd ~

# ===========================
# Backup existing dotfiles that might conflict
# ===========================
echo -e "${YELLOW}Backing up existing dotfiles that might conflict...${NC}"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# ===========================
# List of files/directories that will be stowed
# ===========================
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

# ===========================
# Link modules
# ===========================
for module in "${MODULES[@]}"; do
    echo "Linking $module..."
    stow -R "$module"
done

echo -e "${GREEN}Dotfiles backup saved to: $BACKUP_DIR${NC}"

# ===========================
# Generate SSH key
# ===========================
echo -e "${BLUE}==> Generating SSH key...${NC}"

SSH_KEY="$HOME/.ssh/id_ed25519"
if [ ! -f "$SSH_KEY" ]; then
    mkdir -p "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "phamhuulocforwork@gmail.com" -f "$SSH_KEY" -N ""
    echo -e "${GREEN}SSH key generated at $SSH_KEY${NC}"
else
    echo -e "${YELLOW}SSH key already exists at $SSH_KEY${NC}"
fi

# ===========================
# Copy SSH public key to clipboard (requires xclip or wl-clipboard)
# ===========================
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