#!/bin/bash

# Create github directory if it doesn't exist
if [ ! -d ~/Github ]; then
mkdir ~/Github
fi

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Download Catppuccin theme for zsh-syntax-highlighting
git clone https://github.com/JannoTjarks/catppuccin-zsh.git
mkdir ~/.oh-my-zsh/themes/catppuccin-flavors
ln catppuccin-zsh/catppuccin.zsh-theme ~/.oh-my-zsh/themes/
ln catppuccin-zsh/catppuccin-flavors/* ~/.oh-my-zsh/themes/catppuccin-flavors

# Copy ssh keys to home directory
mkdir -p ~/.ssh
cp /mnt/c/Users/PC/.ssh/id_ed25519 ~/.ssh/
cp /mnt/c/Users/PC/.ssh/id_ed25519.pub ~/.ssh/
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 700 ~/.ssh

# Copy .zshrc to home directory
cp .zshrc ~/.zshrc

# Clean up temporary directories
rm -rf /tmp/catppuccin-zsh-syntax-highlighting

# Make zsh default shell
chsh -s $(which zsh) 