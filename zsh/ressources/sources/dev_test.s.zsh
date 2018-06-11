#!/usr/bin/zsh

zz.dev.runUnittest(){
    cd $HOME/.zsh/ressources/
    grep -h "^[[:blank:]]*assert " **/*.s.zsh(.) | while read line ; do
        eval $line 
    done
    cd -
}
