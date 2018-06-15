#!/usr/bin/zsh

zz.dev.runUnittest(){
    cd $ZDEV_PATH/zsh/ressources/
    while read line ; do
        [[ $line -regex-match "^[[:blank:]]*assert .*$" ]] && eval "$line"
    done < **/*.zsh(.)
    cd -
}
