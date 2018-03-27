#!/usr/bin/zsh

(){
    {
        local MARKED_PATH
        typeset -a MARKED_PATH
        local PATH

        MARKED_PATH=(
            "$HOME/.zsh/ressources/alias"
            "$HOME/.zsh/ressources/functions"
            "$HOME/.zsh/ressources/sources"
        )

        load_marked(){
            typeset FILE
            typeset SPATH=$1
            for FILE in $SPATH/**/*.s.zsh ; do
                source $FILE
            done
        }

        for PATH in $MARKED_PATH ; do
            [[ -d $PATH ]] && load_marked $PATH
        done

    } always {
        unfunction load_marked
    }
}
