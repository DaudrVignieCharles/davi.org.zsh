#!/usr/bin/zsh

zz.plugin.link(){
    if ! [[ $#@ -eq 2 ]] ; then
        printf "zz.plugins.unlink : arguments error : you must pass 2 arguments.\n" "$PLUGIN"
        return 1
    fi
    local PLUGIN=$1
    local PRIORITY=$2
    if ! [[ $PRIORITY = <-> ]] && ! [[ ${#PRIORITY} -eq 3 ]] ; then
        printf "zz.plugins.link : error : invalid arguments : malformed priority number.\n"
        return 1
    fi
    if [[ -z $ZSH_PLUGINS[$PLUGIN] ]] ; then
        printf "zz.plugins.link : error : invalid arguments : plugin %s does not exist.\n" "$PLUGIN"
        return 1
    fi
    ln -s $ZSH_PLUGINS[$PLUGIN] $HOME/.zsh/ressources/plugins/rcs/$PRIORITY\_$PLUGIN.plugin.zsh
    source $HOME/.zsh/ressources/plugins/rcs/$PRIORITY\_$PLUGIN.plugin.zsh
}

zz.plugin.unlink(){
    if ! [[ $#@ -eq 1 ]] ; then
        printf "zz.plugins.unlink : arguments error : you must pass 1 argument.\n" "$PLUGIN"
        return 1
    fi
    local PLUGIN=$1
    local RCPATH=$HOME/.zsh/ressources/plugins/rcs
    if [[ -h $RCPATH/$PLUGIN ]] ; then
        rm $RCPATH/$PLUGIN
    else
        printf "zz.plugins.unlink : error : invalid arguments : plugin link does not exist in rcs directory.\n"
        return 1
    fi
}

__zz_comp_plugin_link(){
    _arguments  '1:Plugin: _path_files -g "$HOME/.zsh/ressources/plugins/ressources/**/*.plugin.zsh(:r:r:t)"' '2:Priority number \: ???'
}

__zz_comp_plugin_unlink(){
    _arguments  '1:Plugin: _path_files -g "$HOME/.zsh/ressources/plugins/rcs/**/*.plugin.zsh(@:t)"'
}

compdef __zz_comp_plugin_link zz.plugin.link
compdef __zz_comp_plugin_unlink zz.plugin.unlink
