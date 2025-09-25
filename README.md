# WSL Ubuntu Terminal Setup

This repository contains configuration files for setting up a modern terminal environment in WSL Ubuntu with Fish shell, Oh My Posh, and Fastfetch.

![Thumbnail](./thumbnail.png)

## Features

- **Fish Shell**: A user-friendly shell with auto-suggestions and syntax highlighting
- **Oh My Posh**: A beautiful and customizable prompt
- **Fastfetch**: A fast system information fetcher (installed from GitHub releases)
- **Docker**: Container platform for development
- **nvm & Node.js**: Node Version Manager with LTS
- **Homebrew**: Package manager for macOS/Linux
- **uv**: Fast Python package manager
- **Modern Tools**: Includes Neovim, Tmux, Lsd, Bat, and other useful terminal tools

## Quick Start

1. **Install WSL (if you haven't already):**

   - Open PowerShell as Administrator and run:
     ```powershell
     wsl --install
     ```
   - Restart your computer if prompted.
   - After installation, open "Ubuntu" from the Start Menu to complete the setup.

2. **Clone this repository:**
   ```bash
   git clone https://github.com/phamhuulocforwork/dotfiles.git
   cd dotfiles
   ```

3. **Run the installation script:**
   ```bash
   sh install.sh
   ```
   *Or if sh is not available:*
   ```bash
   bash install.sh
   ```

4. **Restart your terminal** or run:
   ```bash
   exec $SHELL
   ```
   *Or to use Fish shell:*
   ```bash
   fish
   ```

5. **Configure Git (optional):**
   Edit `~/.gitconfig` with your name and email:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

## Installed Packages

### Core Terminal Tools
- **Fish**: Modern shell with auto-suggestions
- **Fastfetch**: System information display (installed from GitHub releases)
- **Oh My Posh**: Beautiful prompt

### Development Tools
- **Neovim**: Modern text editor
- **Tmux**: Terminal multiplexer
- **Git**: Version control system
- **Docker**: Container platform
- **nvm & Node.js**: Node Version Manager with LTS
- **Homebrew**: Package manager
- **uv**: Fast Python package manager

### Enhanced CLI Tools
- **Lsd**: Modern `ls` replacement with icons
- **Bat**: Enhanced `cat` with syntax highlighting
- **Btop**: Modern system monitor
- **Tree**: Directory tree viewer
- **Unzip**: Archive extraction utility
- **Fzf**: Fuzzy finder
- **Ripgrep**: Fast text search
- **Fd**: Modern `find` replacement

### Additional Tools
- **Jq**: JSON processor
- **P7zip**: Archive utilities
- **Unzip**: Archive extraction utility
- **Openssh-client**: SSH client
- **Build-essential**: C/C++ development tools

## Configuration Files

- `~/.config/fish/config.fish`: Fish shell configuration
- `~/.config/ohmyposh/theme.omp.json`: Oh My Posh theme
- `~/.bashrc`: Bash fallback configuration
- `~/.gitconfig`: Git configuration

## Customization

### Fish Shell
Edit `~/.config/fish/config.fish` to customize your Fish shell experience.

### Oh My Posh
Edit `~/.config/ohmyposh/theme.omp.json` to customize your prompt theme. You can find more themes at [ohmyposh.dev](https://ohmyposh.dev/docs/themes).

### Fastfetch
Edit `~/.config/fastfetch/config.jsonc` to customize the system information display.

## Troubleshooting

### Fish Shell Not Working
If Fish shell doesn't start automatically, run:
```bash
chsh -s /usr/bin/fish
```

### Oh My Posh Not Working
Make sure Oh My Posh is installed and the configuration file exists:
```bash
oh-my-posh --version
```

### Fastfetch Not Working
Check if fastfetch is installed and configured:
```bash
fastfetch --version
```

## Project Structure

```
├── install.sh                    # Main installation script
├── README.md                     # This file
├── builder/                      # Python builder scripts
│   ├── install.py               # Main builder logic
│   ├── packages.py              # Package definitions
│   ├── managers/                 # Manager modules
│   │   ├── filesystem_manager.py
│   │   ├── package_manager.py
│   │   └── post_install_manager.py
│   └── utils/
│       └── schemes.py           # Data structures
└── home/                        # Configuration files
    ├── .bashrc
    ├── .gitconfig
    └── .config/
        ├── fish/                # Fish shell config
        ├── ohmyposh/            # Oh My Posh theme
        └── fastfetch/           # Fastfetch config
```

## License

This project is open source and available under the [MIT License](LICENSE).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.