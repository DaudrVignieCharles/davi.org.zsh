#!/usr/bin/zsh

(){
    export ZSH_PLUGINS
    typeset -Ag ZSH_PLUGINS
    typeset -a tmp
    tmp=( $( echo $HOME/.zsh/ressources/plugins/ressources/**/*.plugin.zsh(.\N) ) )
    local i
    for i in $tmp ; do ZSH_PLUGINS[${i:t:r:r}]="$i" ; done
    unset tmp
    local FILE
    local PLUGIN_PATH=$HOME/.zsh/ressources/plugins/rcs
    for FILE in $PLUGIN_PATH/[0-9][0-9][0-9]_*.plugin.zsh(.\N) ; do
        source $FILE
    done
}
