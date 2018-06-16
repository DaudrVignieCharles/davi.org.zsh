#!/usr/bin/zsh

export ZDEV_PATH=$PWD

() {
    local shell=$(ps -p $$ -ocomm=)
    if [[ "$shell" != "zsh" ]] ; then
        printf "init.zsh must be executed with ZSH.\n"
        return 1
    fi
    local default_shell
    IFS=':'
    default_shell=( $(getent passwd $USER) )
    default_shell=${default_shell[7]}
    default_shell=$default_shell(:t)
    if [[ "$default_shell" != "zsh" ]] ; then
        printf "ZSH is not your default shell.\n"
        printf "Do you want to make it the default shell ? Y/N\n"
        if read -sq ; then
            chsh -s $(whence zsh)
        fi
    fi
    zparseopts ow=OVERWRITE -overwrite=OVERWRITE
    if [[ -z $OVERWRITE ]] ; then
        [[ -f $HOME/.zshrc ]] && mv $HOME/.zshrc $HOME/.zshrc.old
        [[ -d $HOME/.zsh ]] && mv $HOME/.zsh $HOME/.zsh.old
    fi
    if [[ -z $commands[rsync] ]] && ! { type rsync 1>&- } ; then
        printf "\x1b[1;31minit.zsh : warning : rsync not found\x1b[0m
rsync is needed for efficient use of init.zsh and zz.main.update (main_propage.s.zsh).
use of mv as replacement, this will only work for init.zsh and not zz.main.update."
        mv zsh $HOME/.zsh && mv zshrc.zsh $HOME/.zshrc
        return 2
    fi
    source ./zsh/ressources/sources/main_propage.s.zsh &&
    zz.main.propage &&
    source $HOME/.zshrc
} "$@"
