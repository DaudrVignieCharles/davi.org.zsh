#!/usr/bin/zsh

(){
    export PATH=$PATH:$HOME/.cargo/bin;
    if find_item most ${commands:t} ; then
        export MANPAGER=most;
    fi
    if find_item vim ${commands:t} ; then
        export EDITOR=/usr/bin/vim;
    fi
    export GREP_COLOR=31;
    export HISTFILE;
    export SAVEHIST;
    export fpath=( $HOME/.zsh/ressources/autoload $fpath );
}
