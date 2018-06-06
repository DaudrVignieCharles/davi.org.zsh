#!/usr/bin/zsh

zz.main.uninstall(){
    printf "Are you sure you want to uninstall davi.org.zsh ?
Your old zsh folder and your old zshrc and zshenv will come back.
y/n ?
> "
    if read -q ; then
        echo
        [[ -d "$HOME/.zsh.old" ]] && mv $HOME/.zsh.old $HOME/.zsh || rm -r $HOME/.zsh
        [[ -f "$HOME/.zshrc.old" ]] && mv $HOME/.zshrc.old $HOME/.zshrc || rm $HOME/.zshrc
        [[ -f "$HOME/.zshenv.old" ]] && mv $HOME/.zshenv.old $HOME/.zshenv || rm $HOME/.zshenv
        printf "Do you also want to delete the git repository ?
y/n ?
> "
        if read -q ; then
            echo
            [[ -d $ZDEV_PATH ]] && rm -rf $ZDEV_PATH || printf "Unexpected error, git repository not found.\n"
        else
            echo
        fi
    else
        echo
    fi

}
