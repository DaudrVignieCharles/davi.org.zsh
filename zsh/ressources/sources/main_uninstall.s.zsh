#!/usr/bin/zsh

zz.main.uninstall(){
    printf "Are you sure you want to uninstall davi.org.zsh ?
Your old zsh folder and your old zshrc and zshenv will come back.
y/n ?
> "
    if read -q ; then
        echo
        [[ -d "$HOME/.oldzsh/zsh" ]] && mv $HOME/.oldzsh/zsh $HOME/.zsh || rm -r $HOME/.zsh
        [[ -f "$HOME/.oldzsh/zshrc" ]] && mv $HOME/.oldzsh/zshrc $HOME/.zshrc || rm $HOME/.zshrc
        [[ -f "$HOME/.oldzsh/zshenv" ]] && mv $HOME/.oldzsh/zshenv $HOME/.zshenv || rm $HOME/.zshenv
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
