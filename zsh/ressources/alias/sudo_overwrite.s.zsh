#!/usr/bin/zsh

if [[ $UID -ne 0 ]] || [[ $EUID -ne 0 ]] ; then
    () {
        alias lidctl='sudo lidctl'
        alias lumin='sudo lumin'
        alias iftop='sudo iftop_choice'
        alias logspynow='sudo logspynow'
        alias fail2ban-log='sudo fail2ban-log'
        alias dpkg='sudo dpkg'
    }
fi
