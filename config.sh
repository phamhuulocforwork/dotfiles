DOTFILES=".gitconfig .zshrc .zsh_aliases"

for dotfile in $(echo ${DOTFILES[*]});
do
    cp ~/dotfiles/$(echo $dotfile) ~/$(echo $dotfile)
done