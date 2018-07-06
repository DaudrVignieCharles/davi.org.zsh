#!/usr/bin/zsh

(){
    {
        local PATH

        load_source(){
            typeset FILE
            typeset SPATH=$1
            for FILE in $SPATH/**/*.s.zsh(.\N) ; do
                source $FILE
            done
        }

        for PATH in $ZSOURCE_PATH ; do
            [[ -d $PATH ]] && load_source $PATH
        done

    } always {
        unfunction load_marked
    }
}
