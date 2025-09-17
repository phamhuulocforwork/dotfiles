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
CYAN="$(tput setaf 6)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"

# ----------------------------------------------------------
# Log Details
# ----------------------------------------------------------
mkdir -p "$HOME/dotfiles_log"
LOG_FILE="$HOME/dotfiles_log/ssh-generate.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# ----------------------------------------------------------
# Initial Bannar
# ----------------------------------------------------------
clear
echo -e "\n"
echo -e "${CYAN}     ███████╗███████╗██╗  ██╗                                            ${RESET}"
echo -e "${CYAN}     ██╔════╝██╔════╝██║  ██║                                            ${RESET}"
echo -e "${CYAN}     ███████╗███████╗███████║                                            ${RESET}"
echo -e "${CYAN}     ╚════██║╚════██║██╔══██║                                            ${RESET}"
echo -e "${CYAN}     ███████║███████║██║  ██║                                            ${RESET}"
echo -e "${CYAN}     ╚══════╝╚══════╝╚═╝  ╚═╝                                            ${RESET}"
echo -e "${CYAN}                                                                         ${RESET}"
echo -e "${CYAN}      ██████╗ ███████╗███╗   ██╗███████╗██████╗  █████╗ ████████╗███████╗${RESET}"
echo -e "${CYAN}     ██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔════╝${RESET}"
echo -e "${CYAN}     ██║  ███╗█████╗  ██╔██╗ ██║█████╗  ██████╔╝███████║   ██║   █████╗  ${RESET}"
echo -e "${CYAN}     ██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ██╔══██╗██╔══██║   ██║   ██╔══╝  ${RESET}"
echo -e "${CYAN}     ╚██████╔╝███████╗██║ ╚████║███████╗██║  ██║██║  ██║   ██║   ███████╗${RESET}"
echo -e "${CYAN}      ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝${RESET}"
echo -e "\n"

# ----------------------------------------------------------
# Generate SSH key
# ----------------------------------------------------------
echo -e "${NOTE}==> Generating SSH key...${RESET}"

SSH_KEY="$HOME/.ssh/id_ed25519"
if [ ! -f "$SSH_KEY" ]; then
    mkdir -p "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "phamhuulocforwork@gmail.com" -f "$SSH_KEY" -N ""
    echo -e "${OK}SSH key generated at $SSH_KEY${RESET}"
else
    echo -e "${YELLOW}SSH key already exists at $SSH_KEY${RESET}"
fi

# ----------------------------------------------------------
# Copy SSH public key to clipboard (requires xclip or wl-clipboard)
# ----------------------------------------------------------
if command -v wl-copy &>/dev/null; then
    cat "$SSH_KEY.pub" | wl-copy
    echo -e "${OK}SSH public key copied to clipboard (Wayland)${RESET}"
elif command -v xclip &>/dev/null; then
    cat "$SSH_KEY.pub" | xclip -selection clipboard
    echo -e "${OK}SSH public key copied to clipboard (X11)${RESET}"
else
    echo -e "${YELLOW}Neither wl-copy nor xclip found. Please install one to copy SSH key to clipboard.${RESET}"
    echo -e "${YELLOW}You can still get your key with: cat $SSH_KEY.pub${RESET}"
fi