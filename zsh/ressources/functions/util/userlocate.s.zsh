#!/usr/bin/zsh

update-userdb(){
    updatedb --localpaths=$HOME --output=$HOME/.locatedb
}

user-locate(){
    locate --database=$HOME/.locatedb $@
}
