#!/usr/bin/zsh

export ZDEV_PATH=$PWD

() {
    zparseopts ow=OVERWRITE -overwrite=OVERWRITE
    if [[ -z $OVERWRITE ]] ; then
        [[ -f $HOME/.zshrc ]] && mv $HOME/.zshrc $HOME/.zshrc.old
        [[ -d $HOME/.zsh ]] && mv $HOME/.zsh $HOME/.zsh.old
    fi
    if [[ -z $commands[rsync] ]] && ! { type rsync 1>&- }; then
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
