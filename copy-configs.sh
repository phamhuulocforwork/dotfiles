#!/bin/sh

# Tạo thư mục .config nếu chưa có
mkdir -p ./.config

# Copy các config files, đè lên file cũ nếu có
cp -r $HOME/.config/alacritty/ ./.config/
cp -r $HOME/.config/dunst/ ./.config/
cp -r $HOME/.config/hypr/ ./.config/
cp -r $HOME/.config/kitty/ ./.config/
cp -r $HOME/.config/rofi/ ./.config/
cp -r $HOME/.config/waybar/ ./.config/
cp -r $HOME/.config/wlogout/ ./.config/
cp $HOME/.zshrc ./
cp $HOME/.zsh_aliases ./
cp $HOME/.p10k.zsh ./
cp $HOME/.gitconfig ./