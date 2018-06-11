#!/usr/bin/zsh


__launcher(){
    {
        zmodload zsh/curses
        zcurses init
        zcurses addwin main 3 40 $((LINES/2-2)) $((COLUMNS/2-20))
        zcurses attr main white/black
        zcurses border main
        zcurses move main 1 1
        zcurses refresh main
        local user_input raw key map
        local i=1
        until [[ $raw == $NEWLINE ]] || [[ $i -eq 38 ]]; do
            user_input+=$raw
            zcurses input main raw key
            if [[ $key == 'BACKSPACE' ]] ; then
                if [[ $i -gt 1 ]] ; then
                    zcurses move main 1 $((--i))
                    zcurses char main " "
                    zcurses move main 1 $i
                    user_input[-1]=''
                fi
            else
                zcurses char main "$raw"
                ((i++))
            fi
        done
        nohup $user_input &>/dev/null &
    } always {
        zcurses delwin main
        zcurses end
        echo $user_input
    }
}
