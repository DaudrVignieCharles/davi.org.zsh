#!/usr/bin/zsh

zz.dev.unittest(){
    cd $ZDEV_PATH/zsh/ressources/
    grep -h "^[[:blank:]]*assert " **/*.s.zsh(.) | while read line ; do
        eval $line 
    done
}
