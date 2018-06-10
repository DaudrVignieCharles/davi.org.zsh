#!/usr/bin/zsh


# map F1 to zz.main.help
__zz_zle_main_help(){
    BUFFER=zz.main.help
    zle accept-line
}
zle -N zz.main.help
bindkey "^[OP" zz.main.help

# map F5 to zz.dev.refresh
__zz_zle_dev_refresh(){
    BUFFER=zz.dev.refresh
    zle accept-line
}
zle -N zz.dev.refresh
bindkey "^[[15~" zz.dev.refresh
