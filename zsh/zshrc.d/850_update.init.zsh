#!/usr/bin/zsh

() {
    if $AUTO_UPDATE ; then
        if $UPDATE_AUTOSYNC ; then
            zz.main.update
        else
            zz.main.update --no-sync
        fi
    fi
}
