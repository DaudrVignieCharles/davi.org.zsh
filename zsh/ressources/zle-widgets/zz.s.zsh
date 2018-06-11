#!/usr/bin/zsh


# map F1 to zz.main.help
__zz_zle_main_help(){
    BUFFER=zz.main.help
    zle accept-line
}
zle -N __zz_zle_main_help
bindkey "^[OP" __zz_zle_main_help

# map F4 to zz.main.propage
__zz_zle_main_propage(){
    BUFFER=zz.main.propage
    zle accept-line
}
zle -N __zz_zle_main_propage
bindkey "^[OS" __zz_zle_main_propage

# map F5 to zz.dev.refresh
__zz_zle_dev_refresh(){
    BUFFER=zz.dev.refresh
    zle accept-line
}
zle -N __zz_zle_dev_refresh
bindkey "^[[15~" __zz_zle_dev_refresh

# map F6 to zz.dev.runUnittest
__zz_dev_runUnittest(){
    BUFFER=zz.dev.runUnittest
    zle accept-line
}
zle -N __zz_dev_runUnittest
bindkey "^[[17~" __zz_dev_runUnittest
