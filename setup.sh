#!/usr/bin/env bash
set -e

# ----------------------------------------------------------
# Log Details
# ----------------------------------------------------------
mkdir -p "$HOME/dotfiles_log"
LOG_FILE="$HOME/dotfiles_log/install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# ----------------------------------------------------------
# Color-coded status labels
# ----------------------------------------------------------
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

# ----------------------------------------------------------
# Packages
# ----------------------------------------------------------
packages=(
    "wget"
    "unzip"
    "git"
    "gum"    
    "hyprland"
    "waybar"
    "rofi-wayland"
    "kitty"
    "dunst"
    "thunar"
    "xdg-desktop-portal-hyprland"
    "qt5-wayland"
    "qt6-wayland"
    "hyprpaper"
    "hyprlock"
    "firefox"
    "ttf-font-awesome"
    "vim"
    "fastfetch"
    "ttf-fira-sans" 
    "ttf-fira-code" 
    "ttf-firacode-nerd"
    "jq"
    "brightnessctl"
    "networkmanager"
    "wireplumber"
    "wlogout"
    "flatpak"
)

# ----------------------------------------------------------
# Check if command exists
# ----------------------------------------------------------
_checkCommandExists() {
    cmd="$1"
    if ! command -v "$cmd" >/dev/null; then
        echo 1
        return
    fi
    echo 0
    return
}

# ----------------------------------------------------------
# Check if package is already installed
# ----------------------------------------------------------
_isInstalled() {
    package="$1"
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")"
    if [ -n "${check}" ]; then
        echo 0
        return #true
    fi
    echo 1
    return #false
}

# ----------------------------------------------------------
# Install yay
# ----------------------------------------------------------
_installYay() {
    _installPackages "base-devel"
    SCRIPT=$(realpath "$0")
    temp_path=$(dirname "$SCRIPT")
    git clone https://aur.archlinux.org/yay.git $download_folder/yay
    cd $download_folder/yay
    makepkg -si
    cd $temp_path
    echo ":: yay has been installed successfully."
}

# ----------------------------------------------------------
# Install packages
# ----------------------------------------------------------
_installPackages() {
    toInstall=()
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed."
            continue
        fi
        echo "Package not installed: ${pkg}"
        yay --noconfirm -S "${pkg}"
    done
}

# ----------------------------------------------------------
# Initial Bannar
# ----------------------------------------------------------
clear
echo -e "\n"
echo -e "${CYAN}     ███████╗███████╗████████╗██╗   ██╗██████╗ ${RESET}"
echo -e "${CYAN}     ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗${RESET}"
echo -e "${CYAN}     ███████╗█████╗     ██║   ██║   ██║██████╔╝${RESET}"
echo -e "${CYAN}     ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ ${RESET}"
echo -e "${CYAN}     ███████║███████╗   ██║   ╚██████╔╝██║     ${RESET}"
echo -e "${CYAN}     ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ${RESET}"
echo -e "\n"

# ----------------------------------------------------------
# Update system packages
# ----------------------------------------------------------
cd ~

echo -e "${NOTE}Updating system packages...${RESET}"
sudo pacman -Syu --noconfirm

while true; do
    read -p "DO YOU WANT TO START THE PACKAGE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]*)
            echo ":: Installation started."
            echo
            break
            ;;
        [Nn]*)
            echo ":: Installation canceled"
            exit
            break
            ;;
        *)
            echo ":: Please answer yes or no."
            ;;
    esac
done

# Install yay if needed
if [[ $(_checkCommandExists "yay") == 0 ]]; then
    echo ":: yay is already installed"
else
    echo ":: The installer requires yay. yay will be installed now"
    _installYay
fi

# Packages
_installPackages "${packages[@]}"

# ----------------------------------------------------------
# Set locale
# ----------------------------------------------------------
echo -e "${NOTE}Setting locale...${RESET}"
sudo sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
sudo locale-gen
sudo localectl set-locale LANG=en_US.UTF-8

# ----------------------------------------------------------
# Set up terminal environment
# ----------------------------------------------------------
echo -e "${NOTE}==> Setting up terminal environment...${RESET}"
if [[ -f $SCRIPT_DIR/terminal.sh ]]; then
    bash $SCRIPT_DIR/terminal.sh
    echo -e "${OK}==> Terminal setup completed.${RESET}"
else
    echo -e "${ERROR}Error: terminal.sh not found in dotfiles directory.${RESET}"
    exit 1
fi

# ----------------------------------------------------------
# Copy configs
# ----------------------------------------------------------
echo -e "${NOTE}==> Copying configs...${RESET}"
if [[ -f $HOME/dotfiles/copy-configs.sh ]]; then
    bash $HOME/dotfiles/copy-configs.sh
    echo -e "${OK}==> Copying configs completed.${RESET}"
else
    echo -e "${ERROR}Error: copy-configs.sh not found in dotfiles directory.${RESET}"
    exit 1
fi

# ----------------------------------------------------------
# Create Github directory
# ----------------------------------------------------------
echo -e "${NOTE}Creating Github directory...${RESET}"
if [ ! -d ~/Github ]; then
    mkdir ~/Github
    echo -e "${OK}Github directory created${RESET}"
fi

# ----------------------------------------------------------
# Completed
# ----------------------------------------------------------

echo ":: Installation complete."
echo ":: Ready to install the dotfiles with the Dotfiles Installer."