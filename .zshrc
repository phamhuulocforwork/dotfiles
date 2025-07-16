export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

autoload -U promptinit; promptinit
prompt pure

CASE_SENSITIVE="true"
# ENABLE_CORRECTION="true"

plugins=(git docker)

source $ZSH/oh-my-zsh.sh

export EDITOR='code -w'
export TERM=xterm-256color