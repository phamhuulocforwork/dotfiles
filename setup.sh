#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting dotfiles setup for WSL Ubuntu...${NC}"

# Check if running in WSL
if ! grep -qi microsoft /proc/version; then
    echo -e "${YELLOW}⚠️  Warning: This script is designed for WSL Ubuntu${NC}"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Update system packages
echo -e "${BLUE}📦 Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y

# Install essential packages
echo -e "${BLUE}📋 Installing essential packages...${NC}"
sudo apt install -y curl git wget zsh

# Verify Zsh installation
echo -e "${BLUE}🔍 Verifying Zsh installation...${NC}"
if command -v zsh &> /dev/null; then
    echo -e "${GREEN}✅ Zsh installed successfully: $(zsh --version)${NC}"
else
    echo -e "${RED}❌ Zsh installation failed${NC}"
    exit 1
fi

# Install Oh My Zsh
echo -e "${BLUE}⚡ Installing Oh My Zsh...${NC}"
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "${GREEN}✅ Oh My Zsh installed successfully${NC}"
else
    echo -e "${YELLOW}⚠️  Oh My Zsh already installed${NC}"
fi

# Create github directory if it doesn't exist
echo -e "${BLUE}📁 Creating Github directory...${NC}"
if [ ! -d ~/Github ]; then
    mkdir ~/Github
    echo -e "${GREEN}✅ Github directory created${NC}"
fi

# Install zsh-autosuggestions
echo -e "${BLUE}🔌 Installing zsh-autosuggestions...${NC}"
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo -e "${GREEN}✅ zsh-autosuggestions installed${NC}"
else
    echo -e "${YELLOW}⚠️  zsh-autosuggestions already installed${NC}"
fi

# Install zsh-syntax-highlighting
echo -e "${BLUE}🎨 Installing zsh-syntax-highlighting...${NC}"
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo -e "${GREEN}✅ zsh-syntax-highlighting installed${NC}"
else
    echo -e "${YELLOW}⚠️  zsh-syntax-highlighting already installed${NC}"
fi

# Download Catppuccin theme for zsh-syntax-highlighting
echo -e "${BLUE}🌈 Installing Catppuccin theme...${NC}"
if [ ! -d catppuccin-zsh ]; then
    git clone https://github.com/JannoTjarks/catppuccin-zsh.git
fi
mkdir -p ~/.oh-my-zsh/themes/catppuccin-flavors
if [ ! -f ~/.oh-my-zsh/themes/catppuccin.zsh-theme ]; then
    ln -sf "$(pwd)/catppuccin-zsh/catppuccin.zsh-theme" ~/.oh-my-zsh/themes/
fi
if [ ! "$(ls -A ~/.oh-my-zsh/themes/catppuccin-flavors 2>/dev/null)" ]; then
    ln -sf "$(pwd)"/catppuccin-zsh/catppuccin-flavors/* ~/.oh-my-zsh/themes/catppuccin-flavors/
fi
echo -e "${GREEN}✅ Catppuccin theme installed${NC}"

# Copy ssh keys to home directory (if they exist)
echo -e "${BLUE}🔑 Setting up SSH keys...${NC}"
if [ -f /mnt/c/Users/PC/.ssh/id_ed25519 ]; then
    mkdir -p ~/.ssh
    cp /mnt/c/Users/PC/.ssh/id_ed25519 ~/.ssh/
    cp /mnt/c/Users/PC/.ssh/id_ed25519.pub ~/.ssh/
    chmod 600 ~/.ssh/id_ed25519
    chmod 644 ~/.ssh/id_ed25519.pub
    chmod 700 ~/.ssh
    echo -e "${GREEN}✅ SSH keys copied and configured${NC}"
else
    echo -e "${YELLOW}⚠️  SSH keys not found at /mnt/c/Users/PC/.ssh/${NC}"
fi

# Copy .zshrc to home directory
echo -e "${BLUE}⚙️  Applying Zsh configuration...${NC}"
if [ -f .zshrc ]; then
    cp .zshrc ~/.zshrc
    echo -e "${GREEN}✅ .zshrc configuration applied${NC}"
else
    echo -e "${RED}❌ .zshrc file not found${NC}"
fi

# Clean up temporary directories
echo -e "${BLUE}🧹 Cleaning up...${NC}"
rm -rf /tmp/catppuccin-zsh-syntax-highlighting

# Make zsh default shell
echo -e "${BLUE}🐚 Setting Zsh as default shell...${NC}"
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
    echo -e "${GREEN}✅ Zsh set as default shell${NC}"
else
    echo -e "${YELLOW}⚠️  Zsh is already the default shell${NC}"
fi

echo -e "${GREEN}🎉 Setup complete! Please restart your terminal or run 'source ~/.zshrc'${NC}"
echo -e "${BLUE}📝 To verify the theme is applied, run: echo \$ZSH_THEME${NC}" 