HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
bindkey -e

zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

PROMPT='%B%F{magenta}%2~%b%f %# '

#source /usr/share/nvm/init-nvm.sh

alias vimto=nvim
alias bishbash="echo bosh && sleep 1 && exit"
alias bosh="sleep 1 && exit"
alias neofetch="fastfetch && echo using fastfetch alias"
alias fetch="fastfetch && echo using fastfetch alias"
