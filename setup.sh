RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

if ! grep -qi microsoft /proc/version; then
    echo -e "${YELLOW}Warning: This script is designed for WSL Ubuntu${NC}"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo -e "${BLUE}Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y

echo -e "${BLUE}Installing essential packages...${NC}"
sudo apt install -y curl git wget zsh apt-transport-https ca-certificates curl gnupg lsb-release

echo -e "${BLUE}Installing Docker...${NC}"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
echo -e "${GREEN}Docker installed successfully${NC}"

echo -e "${BLUE}Verifying Zsh installation...${NC}"
if command -v zsh &> /dev/null; then
    echo -e "${GREEN}Zsh installed successfully: $(zsh --version)${NC}"
else
    echo -e "${RED}Zsh installation failed${NC}"
    exit 1
fi

echo -e "${BLUE}Installing Oh My Zsh...${NC}"
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "${GREEN}Oh My Zsh installed successfully${NC}"
else
    echo -e "${YELLOW}Oh My Zsh already installed${NC}"
fi

echo -e "${BLUE}Installing nvm (Node Version Manager)...${NC}"
if [ ! -d ~/.nvm ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    echo -e "${GREEN}nvm installed successfully${NC}"
    
    export NVM_DIR="$HOME/.nvm" 
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    
    echo -e "${BLUE}Installing Node.js LTS...${NC}"
    nvm install --lts
    nvm use --lts
    nvm alias default lts/*
    
    echo -e "${GREEN}Node.js LTS installed: $(node --version)${NC}"
    echo -e "${GREEN}npm version: $(npm --version)${NC}"
else
    echo -e "${YELLOW}nvm already installed${NC}"
    
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    if command -v node &> /dev/null; then
        echo -e "${GREEN}Node.js already available: $(node --version)${NC}"
    else
        echo -e "${BLUE}Installing Node.js LTS...${NC}"
        nvm install --lts
        nvm use --lts
        nvm alias default lts/*
        echo -e "${GREEN}Node.js LTS installed: $(node --version)${NC}"
    fi
fi

echo -e "${BLUE}Installing Homebrew...${NC}"
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    
    echo >> ~/.zshrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    
    sudo apt-get install -y build-essential

    echo -e "${GREEN}Homebrew installed successfully${NC}"
else
    echo -e "${YELLOW}Homebrew already installed${NC}"
fi

echo -e "${BLUE}Installing uv (Python package manager)...${NC}"
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    export PATH="$HOME/.cargo/bin:$PATH"
    
    echo -e "${GREEN}uv installed successfully${NC}"
else
    echo -e "${YELLOW}uv already installed${NC}"
fi

echo -e "${BLUE}Creating Github directory...${NC}"
if [ ! -d ~/Github ]; then
    mkdir ~/Github
    echo -e "${GREEN}Github directory created${NC}"
fi

echo -e "${BLUE}Installing zsh-autosuggestions...${NC}"
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo -e "${GREEN}zsh-autosuggestions installed${NC}"
else
    echo -e "${YELLOW}zsh-autosuggestions already installed${NC}"
fi

echo -e "${BLUE}Installing zsh-syntax-highlighting...${NC}"
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo -e "${GREEN}zsh-syntax-highlighting installed${NC}"
else
    echo -e "${YELLOW}zsh-syntax-highlighting already installed${NC}"
fi

echo -e "${BLUE}Installing Catppuccin theme...${NC}"
if [ ! -d catppuccin-zsh ]; then
    git clone https://github.com/JannoTjarks/catppuccin-zsh.git
fi
mkdir -p ~/.oh-my-zsh/themes/catppuccin-flavors
if [ ! -f ~/.oh-my-zsh/themes/catppuccin.zsh-theme ]; then
    ln -sf "$(pwd)/catppuccin-zsh/catppuccin.zsh-theme" ~/.oh-my-zsh/themes/
fi
if [ ! "$(ls -A ~/.oh-my-zsh/themes/catppuccin-flavors 2>/dev/null)" ]; then
    ln -sf "$(pwd)"/catppuccin-zsh/catppuccin-flavors/* ~/.oh-my-zsh/themes/catppuccin-flavors/
fi
echo -e "${GREEN}Catppuccin theme installed${NC}"

echo -e "${BLUE}Setting up SSH keys...${NC}"
if [ -f /mnt/c/Users/PC/.ssh/id_ed25519 ]; then
    mkdir -p ~/.ssh
    cp /mnt/c/Users/PC/.ssh/id_ed25519 ~/.ssh/
    cp /mnt/c/Users/PC/.ssh/id_ed25519.pub ~/.ssh/
    chmod 600 ~/.ssh/id_ed25519
    chmod 644 ~/.ssh/id_ed25519.pub
    chmod 700 ~/.ssh
    echo -e "${GREEN}SSH keys copied and configured${NC}"
else
    echo -e "${YELLOW}SSH keys not found at /mnt/c/Users/PC/.ssh/${NC}"
fi

echo -e "${BLUE}Applying Zsh configuration...${NC}"
if [ -f .zshrc ]; then
    cp .zshrc ~/.zshrc
    echo -e "${GREEN}.zshrc configuration applied${NC}"
else
    echo -e "${RED}.zshrc file not found${NC}"
fi

echo -e "${BLUE}Cleaning up...${NC}"
rm -rf /tmp/catppuccin-zsh-syntax-highlighting

echo -e "${BLUE}Setting Zsh as default shell...${NC}"
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
    echo -e "${GREEN}Zsh set as default shell${NC}"
else
    echo -e "${YELLOW}Zsh is already the default shell${NC}"
fi

echo -e "${GREEN}Setup complete! Please restart your terminal or run 'source ~/.zshrc'${NC}"
echo -e "${BLUE}To verify the theme is applied, run: echo \$ZSH_THEME${NC}" 