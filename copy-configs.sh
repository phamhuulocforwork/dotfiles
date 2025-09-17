#!/bin/sh

# Tạo thư mục .config trong HOME nếu chưa có
mkdir -p $HOME/.config

# Copy các config files từ repo vào HOME, đè lên file cũ nếu có
cp -r ./.config/alacritty/ $HOME/.config/
cp -r ./.config/dunst/ $HOME/.config/
cp -r ./.config/hypr/ $HOME/.config/
cp -r ./.config/kitty/ $HOME/.config/
cp -r ./.config/rofi/ $HOME/.config/
cp -r ./.config/waybar/ $HOME/.config/
cp -r ./.config/wlogout/ $HOME/.config/
cp ./.zshrc $HOME/
cp ./.zsh_aliases $HOME/
cp ./.p10k.zsh $HOME/