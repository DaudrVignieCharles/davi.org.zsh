#!/usr/bin/zsh

zz.dev.refresh(){
    zz.main.propage
    source $HOME/.zshenv
    source $HOME/.zshrc
    cd $HOME/.zsh/ressources/
    grep -h "^[[:blank:]]*assert " **/*.s.zsh(.) | while read line ; do
        eval $line 
    done
    cd -
}
