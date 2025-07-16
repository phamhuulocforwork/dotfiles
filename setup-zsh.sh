#!/bin/bash

echo "🚀 Setting up Oh My Zsh with plugins and theme..."

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Copy .zshrc to home directory
cp .zshrc ~/.zshrc

echo "✅ Oh My Zsh setup completed!"
echo "📝 Please restart your terminal or run 'source ~/.zshrc'"
echo "🎨 Run 'p10k configure' to configure Powerlevel10k theme"

# Make zsh default shell
echo "🔄 Making zsh the default shell..."
chsh -s $(which zsh)

echo "🎉 Setup complete! Please restart your terminal." 