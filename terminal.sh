#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

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

echo -e "${BLUE}==> Installing pacman packages...${NC}"
sudo pacman -Syu --noconfirm "${pacman_packages[@]}"

echo -e "${BLUE}==> Installing AUR packages...${NC}"
yay -S --noconfirm "${aur_packages[@]}"

# -------------------- Docker --------------------
echo -e "${BLUE}==> Setting up Docker...${NC}"
if command -v docker &>/dev/null; then
    sudo systemctl enable --now docker.service
    sudo usermod -aG docker "${USER:-$(id -un)}"
    echo -e "${GREEN}Docker installed and enabled${NC}"
else
    echo -e "${RED}Docker is not installed. Skipping setup.${NC}"
fi

# -------------------- Python pip --------------------
echo -e "${BLUE}==> Allow pip install by removing EXTERNALLY-MANAGED file${NC}"
EXTERNALLY_MANAGED_FILE=$(python3 -c "import sys; print(f'/usr/lib/python{sys.version_info.major}.{sys.version_info.minor}/EXTERNALLY-MANAGED')")
if [ -f "$EXTERNALLY_MANAGED_FILE" ]; then
    sudo rm -f "$EXTERNALLY_MANAGED_FILE"
    echo -e "${GREEN}Removed $EXTERNALLY_MANAGED_FILE${NC}"
else
    echo -e "${YELLOW}No EXTERNALLY-MANAGED file found${NC}"
fi

# -------------------- Zsh --------------------
echo -e "${BLUE}==> Verifying Zsh installation...${NC}"
if command -v zsh &>/dev/null; then
    echo -e "${GREEN}Zsh installed: $(zsh --version)${NC}"
else
    echo -e "${RED}Zsh installation failed${NC}"
    exit 1
fi

echo -e "${BLUE}==> Installing Oh My Zsh...${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "${GREEN}Oh My Zsh installed${NC}"
else
    echo -e "${YELLOW}Oh My Zsh already installed${NC}"
fi

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo -e "${BLUE}==> Setting Zsh as default shell...${NC}"
    chsh -s "$(which zsh)"
    echo -e "${GREEN}Zsh set as default shell${NC}"
fi

# -------------------- uv (Python package manager) --------------------
echo -e "${BLUE}==> Installing uv...${NC}"
if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    if ! grep -q 'cargo/bin' "$HOME/.zshrc"; then
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$HOME/.zshrc"
    fi
    export PATH="$HOME/.cargo/bin:$PATH"
    echo -e "${GREEN}uv installed${NC}"
else
    echo -e "${YELLOW}uv already installed${NC}"
fi

# -------------------- Zsh Plugins --------------------
echo -e "${BLUE}==> Installing zsh-autosuggestions...${NC}"
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    echo -e "${GREEN}zsh-autosuggestions installed${NC}"
else
    echo -e "${YELLOW}zsh-autosuggestions already installed${NC}"
fi

echo -e "${BLUE}==> Installing zsh-syntax-highlighting...${NC}"
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    echo -e "${GREEN}zsh-syntax-highlighting installed${NC}"
else
    echo -e "${YELLOW}zsh-syntax-highlighting already installed${NC}"
fi

# -------------------- Theme --------------------
echo -e "${BLUE}==> Installing Catppuccin Zsh theme...${NC}"
THEME_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/catppuccin-zsh"
if [ ! -d "$THEME_DIR" ]; then
    git clone https://github.com/JannoTjarks/catppuccin-zsh.git "$THEME_DIR"
fi

ln -sf "$THEME_DIR/catppuccin.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/catppuccin.zsh-theme"
mkdir -p "$HOME/.oh-my-zsh/custom/themes/catppuccin-flavors"
ln -sf "$THEME_DIR/catppuccin-flavors/"* "$HOME/.oh-my-zsh/custom/themes/catppuccin-flavors/"

if ! grep -q 'ZSH_THEME="catppuccin"' "$HOME/.zshrc"; then
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="catppuccin"/' "$HOME/.zshrc"
    echo -e "${GREEN}Zsh theme set to Catppuccin${NC}"
fi

echo -e "${GREEN}Setup complete! Please restart your terminal or run 'source ~/.zshrc'${NC}"
echo -e "${BLUE}To verify the theme is applied, run: echo \$ZSH_THEME${NC}" 
