#!/bin/bash

# Install Catppuccin zsh theme
git clone https://github.com/JannoTjarks/catppuccin-zsh.git /tmp/catppuccin-zsh
mkdir -p ~/.oh-my-zsh/themes/catppuccin-flavors
ln -sf /tmp/catppuccin-zsh/catppuccin.zsh-theme ~/.oh-my-zsh/themes/
ln -sf /tmp/catppuccin-zsh/catppuccin-flavors/* ~/.oh-my-zsh/themes/catppuccin-flavors/

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install Catppuccin zsh-syntax-highlighting theme
git clone https://github.com/catppuccin/zsh-syntax-highlighting.git /tmp/catppuccin-zsh-syntax-highlighting
mkdir -p ~/.zsh
cp -v /tmp/catppuccin-zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh ~/.zsh/

# Install zsh-syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Copy .zshrc to home directory
cp .zshrc ~/.zshrc

# Clean up temporary directories
rm -rf /tmp/catppuccin-zsh
rm -rf /tmp/catppuccin-zsh-syntax-highlighting

# Make zsh default shell
chsh -s $(which zsh) 