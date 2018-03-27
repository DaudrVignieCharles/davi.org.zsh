#!/usr/bin/zsh

(){
    if [ -z "$HISTFILE" ]; then
        HISTFILE=$HOME/.zsh_history;
    fi
    HISTSIZE=10000;
    SAVEHIST=10000;
    case $HIST_STAMPS in
        ("mm/dd/yyyy") alias history='fc -fl 1' ;;
        ("dd.mm.yyyy") alias history='fc -El 1' ;;
        ("yyyy-mm-dd") alias history='fc -il 1' ;;
        *) alias history='fc -l 1' ;;
    esac
}
