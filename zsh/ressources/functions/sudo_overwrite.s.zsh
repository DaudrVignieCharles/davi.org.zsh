#!/usr/bin/zsh

if [[ $(id --user) -ne 0 ]] ; then
    apt(){
        (( $# == 0 )) && { /usr/bin/apt ; return 0 }
        typeset -a suaptcmd
        suaptcmd=(install update upgrade remove purge autoremove
            full-upgrade dist-upgrade edit-sources autoclean)
        if [[ -n ${suaptcmd[(r)$1]} ]]; then
            sudo /usr/bin/apt "$@"
        else
            /usr/bin/apt "$@"
        fi
    }
fi
