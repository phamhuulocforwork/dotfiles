#!/bin/bash

clear
echo """
                      ▄▀▄     ▄▀▄           ▄▄▄▄▄
                     ▄█░░▀▀▀▀▀░░█▄         █░▄▄░░█
                 ▄▄  █░░░░░░░░░░░█  ▄▄    █░█  █▄█
                █▄▄█ █░░▀░░┬░░▀░░█ █▄▄█  █░█
██████╗░██╗██╗░░░░░██╗░░░░░██╗░░░░██╗███████╗██╗░░░░░
██╔══██╗██║██║░░░░░██║░░░░░██║░░░░██║██╔════╝██║░░░░░
██████╔╝██║██║░░░░░██║░░░░░██║░█╗░██║███████╗██║░░░░░
██╔══██╗██║██║░░░░░██║░░░░░██║███╗██║╚════██║██║░░░░░
██████╔╝██║███████╗███████╗╚███╔███╔╝███████║███████╗
╚═════╝░╚═╝╚══════╝╚══════╝░╚══╝╚══╝░╚══════╝╚══════╝
"""
echo
echo "Starting WSL Ubuntu terminal setup..." && sleep 2

# Check if running in WSL
if ! grep -qi microsoft /proc/version; then
    echo "Warning: This script is designed for WSL Ubuntu"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

##==> Update system
#######################################################
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y
#######################################################

##==> Installing basic dependencies
#######################################################
echo "Installing basic dependencies..."
sudo apt install -y python3 python3-pip
#######################################################

##==> Installing python and dependencies for it
#######################################################
declare -a packages=(
	"inquirer"
	"loguru"
	"psutil"
	"pyyaml"
	"pillow"
	"colorama"
)

for package in "${packages[@]}"; do
    if ! pip3 show $package &> /dev/null; then
        pip3 install $package --break-system-packages
    fi
done
#######################################################

##==> Building the system
#######################################################
python3 builder/install.py
