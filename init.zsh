#!/usr/bin/zsh

export ZDEV_PATH=$PWD

() {
    local shell=$(ps -p $$ -ocomm=)
    if [[ "$shell" != "zsh" ]] ; then
        printf "init.zsh must be executed with ZSH.\n"
        return 1
    fi
    local file
    for file in ./**/*(.) ; do
        chmod 644 $file
    done
    local directory
    for directory in ./**/*(/) ; do
        chmod 755 $directory
    done
    chmod 744 init.zsh
    local default_shell
    IFS=':'
    default_shell=( $(getent passwd $USER) )
    default_shell=${default_shell[7]}
    default_shell=$default_shell(:t)
    if [[ "$default_shell" != "zsh" ]] ; then
        printf "ZSH is not your default shell.\n"
        printf "Do you want to make it the default shell ? Y/N\n"
        if read -sq ; then
            while ! chsh -s $(whence zsh) ; do
                printf "Error while setting ZSH as default shell.\n"
                printf "Would you want to restart ? Y/N\n"
                if ! read -sq ; then
                    break
                fi
            done
        fi
fi
    zparseopts ow=OVERWRITE -overwrite=OVERWRITE
    if [[ -z $OVERWRITE ]] ; then
        [[ -d $HOME/.oldzsh ]] || mkdir $HOME/.oldzsh
        [[ -f $HOME/.zshrc ]] && mv $HOME/.zshrc $HOME/.oldzsh/zshrc
        [[ -f $HOME/.zshenv ]] && mv $HOME/.zshenv $HOME/.oldzsh/zshenv
        [[ -d $HOME/.zsh ]] && mv $HOME/.zsh $HOME/.oldzsh/zsh
    fi
    if [[ -z $commands[rsync] ]] && ! { type rsync 1>&- } ; then
        printf "\x1b[1;31minit.zsh : warning : rsync not found\x1b[0m
rsync is needed for efficient use of init.zsh and \
zz.main.update (main_propage.s.zsh).
use of mv as replacement, this will only work for init.zsh and \
not zz.main.update."
        cp zshrc.zsh $HOME/.zshrc
        cp zshenv.zsh $HOME/.zshenv
        cp zsh $HOME/.zsh
        return 2
    fi
    source ./zsh/ressources/sources/main_propage.s.zsh &&
    zz.main.propage &&
    source $HOME/.zshrc
} "$@"
