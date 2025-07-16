#!/bin/bash

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Create .zsh directory for themes
mkdir -p ~/.zsh

# Download Catppuccin theme for zsh-syntax-highlighting
curl -o ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh

# Copy .zshrc to home directory
cp .zshrc ~/.zshrc

# Clean up temporary directories
rm -rf /tmp/catppuccin-zsh-syntax-highlighting

# Make zsh default shell
chsh -s $(which zsh) 