#!/usr/bin/env bash
set -e

# ----------------------------------------------------------
# Log Details
# ----------------------------------------------------------
mkdir -p "$HOME/dotfiles_log"
LOG_FILE="$HOME/dotfiles_log/terminal.log"
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
pacman_packages=(
    # System monitoring and fun terminal visuals
    btop cmatrix fastfetch

    # Essential utilities
    make curl wget unzip fzf eza bat zoxide neovim tmux ripgrep fd openssh netcat docker docker-compose stow

    # Programming languages
    python python-pip pnpm

    # Shell & customization
    zsh
)

aur_packages=(
    # Browser
    zen-browser-bin
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
    pkg="$1"
    # Check pacman
    pacman_check="$(sudo pacman -Qs --color always "${pkg}" | grep "local" | grep "${pkg} ")"
    if [ -n "${pacman_check}" ]; then
        echo 0
        return # true
    fi
    # Check AUR (yay)
    if command -v yay &>/dev/null; then
        aur_check="$(yay -Qs "${pkg}" | grep "local" | grep "${pkg} ")"
        if [ -n "${aur_check}" ]; then
            echo 0
            return # true
        fi
    fi
    echo 1
    return # false
}

# ----------------------------------------------------------
# Initial Bannar
# ----------------------------------------------------------
clear
echo -e "\n"
echo -e "${CYAN}     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗     ${RESET}"
echo -e "${CYAN}     ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║     ${RESET}"
echo -e "${CYAN}        ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║     ${RESET}"
echo -e "${CYAN}        ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║     ${RESET}"
echo -e "${CYAN}        ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗${RESET}"
echo -e "${CYAN}        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝${RESET}"
echo -e "\n"

echo -e "${NOTE}==> Installing pacman packages...${RESET}"
sudo pacman -Syu --noconfirm "${pacman_packages[@]}"

echo -e "${NOTE}==> Installing AUR packages...${RESET}"
yay -S --noconfirm "${aur_packages[@]}"

# ----------------------------------------------------------
# Setting up Docker
# ----------------------------------------------------------
echo -e "${NOTE}==> Setting up Docker...${RESET}"
if command -v docker &>/dev/null; then
    sudo systemctl enable --now docker.service
    sudo usermod -aG docker "${USER:-$(id -un)}"
    echo -e "${OK}Docker installed and enabled${RESET}"
else
    echo -e "${RED}Docker is not installed. Skipping setup.${RESET}"
fi

# ----------------------------------------------------------
# Allow pip install by removing EXTERNALLY-MANAGED file
# ----------------------------------------------------------
echo -e "${NOTE}==> Allow pip install by removing EXTERNALLY-MANAGED file${RESET}"
EXTERNALLY_MANAGED_FILE=$(python3 -c "import sys; print(f'/usr/lib/python{sys.version_info.major}.{sys.version_info.minor}/EXTERNALLY-MANAGED')")
if [ -f "$EXTERNALLY_MANAGED_FILE" ]; then
    sudo rm -f "$EXTERNALLY_MANAGED_FILE"
    echo -e "${OK}Removed $EXTERNALLY_MANAGED_FILE${RESET}"
else
    echo -e "${WARN}No EXTERNALLY-MANAGED file found${RESET}"
fi

# ----------------------------------------------------------
# Verifying Zsh installation
# ----------------------------------------------------------
echo -e "${NOTE}==> Verifying Zsh installation...${RESET}"
if command -v zsh &>/dev/null; then
    echo -e "${OK}Zsh installed: $(zsh --version)${RESET}"
else
    echo -e "${RED}Zsh installation failed${RESET}"
    exit 1
fi

# ----------------------------------------------------------
# Installing Oh My Zsh
# ----------------------------------------------------------
echo -e "${NOTE}==> Installing Oh My Zsh...${RESET}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "${OK}Oh My Zsh installed${RESET}"
else
    echo -e "${WARN}Oh My Zsh already installed${RESET}"
fi

# ----------------------------------------------------------
# Setting Zsh as default shell
# ----------------------------------------------------------
if [ "$SHELL" != "$(which zsh)" ]; then
    echo -e "${NOTE}==> Setting Zsh as default shell...${RESET}"
    chsh -s "$(which zsh)"
    echo -e "${OK}Zsh set as default shell${RESET}"
fi

# ----------------------------------------------------------
# Installing uv (Python package manager)
# ----------------------------------------------------------
echo -e "${NOTE}==> Installing uv...${RESET}"
if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    if ! grep -q 'cargo/bin' "$HOME/.zshrc"; then
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$HOME/.zshrc"
    fi
    export PATH="$HOME/.cargo/bin:$PATH"
    echo -e "${OK}uv installed${RESET}"
else
    echo -e "${WARN}uv already installed${RESET}"
fi

# ----------------------------------------------------------
# Installing zsh-autosuggestions
# ----------------------------------------------------------
echo -e "${NOTE}==> Installing zsh-autosuggestions...${RESET}"
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    echo -e "${OK}zsh-autosuggestions installed${RESET}"
else
    echo -e "${WARN}zsh-autosuggestions already installed${RESET}"
fi

# ----------------------------------------------------------
# Installing zsh-syntax-highlighting
# ----------------------------------------------------------
echo -e "${NOTE}==> Installing zsh-syntax-highlighting...${RESET}"
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    echo -e "${OK}zsh-syntax-highlighting installed${RESET}"
else
    echo -e "${WARN}zsh-syntax-highlighting already installed${RESET}"
fi

# ----------------------------------------------------------
# Installing Catppuccin Zsh theme
# ----------------------------------------------------------
echo -e "${NOTE}==> Installing Catppuccin Zsh theme...${RESET}"
THEME_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/catppuccin-zsh"
if [ ! -d "$THEME_DIR" ]; then
    git clone https://github.com/JannoTjarks/catppuccin-zsh.git "$THEME_DIR"
fi

ln -sf "$THEME_DIR/catppuccin.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/catppuccin.zsh-theme"
mkdir -p "$HOME/.oh-my-zsh/custom/themes/catppuccin-flavors"
ln -sf "$THEME_DIR/catppuccin-flavors/"* "$HOME/.oh-my-zsh/custom/themes/catppuccin-flavors/"

if ! grep -q 'ZSH_THEME="catppuccin"' "$HOME/.zshrc"; then
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="catppuccin"/' "$HOME/.zshrc"
    echo -e "${OK}Zsh theme set to Catppuccin${RESET}"
fi

echo -e "${OK}Setup complete! Please restart your terminal or run 'source ~/.zshrc'${RESET}"
echo -e "${NOTE}To verify the theme is applied, run: echo \$ZSH_THEME${RESET}" 
