#!/usr/bin/env bash
set -e

# ----------------------------------------------------------
# Color-coded status labels
# ----------------------------------------------------------
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
WARN="$(tput setaf 3)[WARN]$(tput sgr0)"
OK="$(tput setaf 2)[OK]$(tput sgr0)"
NOTE="$(tput setaf 6)[NOTE]$(tput sgr0)"
ACTION="$(tput setaf 5)[ACTION]$(tput sgr0)"
RESET="$(tput sgr0)"

# ----------------------------------------------------------
# Copy function with error handling
# ----------------------------------------------------------
_copyConfig() {
    local src="$1"
    local dest="$2"

    if [[ ! -e "$src" ]]; then
        echo -e "${WARN}Source does not exist: $src${RESET}"
        return 1
    fi

    echo -e "${ACTION}Copying $src to $dest${RESET}"
    if cp -r -l "$src" "$dest"; then
        echo -e "${OK}Successfully copied $src${RESET}"
    else
        echo -e "${ERROR}Failed to copy $src${RESET}"
        return 1
    fi
}

# Create necessary directories
mkdir -p ./.config ./zsh

# Copy configuration directories
_copyConfig "$HOME/.config/alacritty/" "./.config/" || true
_copyConfig "$HOME/.config/dunst/" "./.config/" || true
_copyConfig "$HOME/.config/hypr/" "./.config/" || true
_copyConfig "$HOME/.config/kitty/" "./.config/" || true
_copyConfig "$HOME/.config/rofi/" "./.config/" || true
_copyConfig "$HOME/.config/waybar/" "./.config/" || true
_copyConfig "$HOME/.config/wlogout/" "./.config/" || true

# Copy zsh configuration files
_copyConfig "$HOME/.zshrc" "./zsh/" || true
_copyConfig "$HOME/.zsh_aliases" "./zsh/" || true
_copyConfig "$HOME/.p10k.zsh" "./zsh/" || true

# Copy git config (without -r flag for single file)
if [[ -f "$HOME/.gitconfig" ]]; then
    echo -e "${ACTION}Copying $HOME/.gitconfig to ./"
    if cp -l "$HOME/.gitconfig" "./"; then
        echo -e "${OK}Successfully copied .gitconfig${RESET}"
    else
        echo -e "${ERROR}Failed to copy .gitconfig${RESET}"
    fi
else
    echo -e "${WARN}.gitconfig does not exist${RESET}"
fi

echo -e "${OK}Configuration copying completed${RESET}"
