# Dotfiles Configuration with WSL, Zsh & Oh My Zsh

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

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install essential packages
sudo apt install -y curl git wget
```

### 🐚 Step 3: Install Zsh

```bash
# Install Zsh
sudo apt install -y zsh

# Verify installation
zsh --version
```

### ⚡ Step 4: Install Oh My Zsh

```bash
# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 📁 Step 5: Clone and Apply Dotfiles

```bash
# Clone dotfiles repository
cd ~
git clone https://github.com/phamhuulocforwork/dotfiles.git

# Navigate to dotfiles directory
cd dotfiles

# Apply configuration
chmod +x config.sh
./config.sh

# Run setup script
chmod +x setup-zsh.sh
./setup-zsh.sh
```

### 🎨 Step 6: Finalize Installation

```bash
# Restart terminal or
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

### 📝 Reload Dotfiles

```bash
# Reload configuration after editing
./reload-dotfiles.sh

# Or use alias
reload
```

---

## 📂 Repository Structure

```txt
dotfiles/
├── .zshrc                    # Main Zsh configuration
├── .zsh_aliases             # Custom aliases
├── .gitconfig               # Git configuration
├── setup-zsh.sh             # Zsh setup script
├── config.sh                # Dotfiles deployment script
├── reload-dotfiles.sh       # Reload configuration script
└── README.md                # This file
```

## 🤝 Contributing

Feel free to fork this repository and customize the dotfiles according to your needs!

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
