#!/usr/bin/zsh

(){
    export PATH=$PATH:$HOME/.cargo/bin;
    export PYTHONPATH=$PYTHONPATH:$HOME/sync.save/programation/python/missalibs/;
    export MANPAGER=most;
    export EDITOR=/usr/bin/vim;
    export GREP_COLOR=31;
    export HISTFILE;
    export SAVEHIST;
    export fpath=( $HOME/.zsh/ressources/autoload $fpath );
}
