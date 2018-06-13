#!/usr/bin/zsh

zz.dev.runUnittest(){
    cd $HOME/.zsh/ressources/
    while read line ; do
        [[ $line -regex-match "^[[:blank:]]*assert .*$" ]] && eval "$line"
    done < **/*.zsh(.)
    cd -
}
