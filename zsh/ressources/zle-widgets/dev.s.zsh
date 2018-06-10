#!/usr/bin/zsh

zz.dev.refresh(){
    zz.main.propage
    source $HOME/.zshenv
    source $HOME/.zshrc
    zz.dev.unittest
}

alias __zz_zle_dev_refresh="zz.dev.refresh"

zle -N __zz_zle_dev_refresh
bindkey "^[[15~" __zz_zle_dev_refresh
