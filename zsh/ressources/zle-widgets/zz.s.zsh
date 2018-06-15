#!/usr/bin/zsh


# map F1 to zz.main.help
__zz_zle_main_help(){
    BUFFER=zz.main.help
    zle accept-line
}
zle -N __zz_zle_main_help
bindkey "^[OP" __zz_zle_main_help

# map F2 to __launcher

__zz_zle_main_launcher(){
    BUFFER=__launcher
    zle accept-line
}
zle -N __zz_zle_main_launcher
bindkey "^[OQ" __zz_zle_main_launcher

# map F3 to cd $ZDEV_PATH
__zz_zle_main_cdz(){
    BUFFER="cd $ZDEV_PATH && clear"
    zle accept-line
}
zle -N __zz_zle_main_cdz
bindkey "^[OR" __zz_zle_main_cdz

# map F4 to zz.main.propage
__zz_zle_main_propage(){
    BUFFER=zz.main.propage
    zle accept-line
}
zle -N __zz_zle_main_propage
bindkey "^[OS" __zz_zle_main_propage

# map F5 to zz.dev.refresh
__zz_zle_main_refresh(){
    BUFFER=zz.main.refresh
    zle accept-line
}
zle -N __zz_zle_main_refresh
bindkey "^[[15~" __zz_zle_main_refresh

# map F6 to zz.dev.runUnittest
__zz_dev_runUnittest(){
    BUFFER=zz.dev.runUnittest
    zle accept-line
}
zle -N __zz_dev_runUnittest
bindkey "^[[17~" __zz_dev_runUnittest

# map F10 to user locate
__zz_zle_locate(){
    BUFFER=__locatebox
    zle accept-line
}
zle -N __zz_zle_locate
bindkey "^[[21~" __zz_zle_locate
