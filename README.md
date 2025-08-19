# Dotfiles Configuration with WSL, Zsh & Oh My Zsh

![Thumbnail](./thumbnail.png)

## Complete Installation and Configuration Guide

### 📋 System Requirements

- Windows 10 version 2004 and higher or Windows 11
- PowerShell with Administrator privileges

### 🚀 Step 1: Install WSL (Windows Subsystem for Linux)

```powershell
# Enable WSL feature
wsl --install

# Or install Ubuntu specifically
wsl --install -d Ubuntu
```

**Restart your computer** after installation completes.

### 🐧 Step 2: Setup WSL Ubuntu

Open WSL Ubuntu and create user account when prompted.

### 📁 Step 3: Clone and Apply Dotfiles

```bash
# Clone dotfiles repository
cd ~
git clone https://github.com/phamhuulocforwork/dotfiles.git

# Navigate to dotfiles directory
cd dotfiles

# Apply configuration (optional - for additional config files)
chmod +x config.sh
./config.sh

# Run automated setup script (this will handle everything!)
chmod +x setup.sh
./setup.sh
```

**The setup script will automatically handle:**

- System updates and essential package installation
- Zsh installation and verification
- Oh My Zsh installation
- nvm (Node Version Manager) and Node.js LTS installation
- Plugin installation (zsh-autosuggestions, zsh-syntax-highlighting)
- Catppuccin theme setup
- SSH key configuration (if available)
- Zsh configuration application
- Setting Zsh as default shell

### 🎨 Step 4: Finalize Installation

```bash
# Restart terminal or reload configuration
source ~/.zshrc

# Verify theme is applied
echo $ZSH_THEME
```

### 🛠️ Installed Features

- **Theme**: Catppuccin Mocha with beautiful colors
- **Plugins**:
  - `zsh-autosuggestions` - Automatic command suggestions
  - `zsh-syntax-highlighting` - Syntax highlighting with Catppuccin theme
  - `git`, `docker`, `npm`, `node`, `yarn`, `vscode`, `github`
- **Aliases**: Useful shortcuts for development
- **Functions**: `mkcd`, `gitinit`, `clone` functions

---

## 📂 Repository Structure

```txt
dotfiles/
├── .zshrc                   # Main Zsh configuration
├── .zsh_aliases             # Custom aliases
├── .gitconfig               # Git configuration
├── setup.sh                 # Automated setup script
├── config.sh                # Dotfiles deployment script
└── README.md                # This file
```

## 🤝 Contributing

Feel free to fork this repository and customize the dotfiles according to your needs!

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
