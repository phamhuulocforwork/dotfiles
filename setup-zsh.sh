#!/bin/bash

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Download Catppuccin theme for zsh-syntax-highlighting
git clone https://github.com/JannoTjarks/catppuccin-zsh.git
mkdir ~/.oh-my-zsh/themes/catppuccin-flavors
ln catppuccin-zsh/catppuccin.zsh-theme ~/.oh-my-zsh/themes/
ln catppuccin-zsh/catppuccin-flavors/* ~/.oh-my-zsh/themes/catppuccin-flavors

# Copy .zshrc to home directory
cp .zshrc ~/.zshrc

# Clean up temporary directories
rm -rf /tmp/catppuccin-zsh-syntax-highlighting

# Make zsh default shell
chsh -s $(which zsh) 