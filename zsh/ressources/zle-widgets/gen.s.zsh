#!/usr/bin/zsh

# fu $MVCURSOR (+x|-x|=) $INS_STR
__zz_zle_gen_insert(){
    typeset MV_CURSOR INS_STR
    MV_CURSOR=$1
    INS_STR=$2
    BUFFER="${LBUFFER}${INS_STR}${RBUFFER}" 
    if [[ "$MV_CURSOR" == "=" ]] ; then
        return 0
    else
        CURSOR=$(( $CURSOR $MV_CURSOR ))
    fi
} 

__locatebox(){
    {
        zmodload zsh/curses
        setopt ksharrays
        zcurses init
        zcurses addwin main 3 40 $((LINES/2-2)) $((COLUMNS/2-20))
        zcurses attr main white/black
        zcurses border main
        zcurses addwin inputbox 1 38 $((LINES/2-1)) $((COLUMNS/2-19)) main
        zcurses attr inputbox white/black
        zcurses move inputbox 0 0
        zcurses refresh main
        zcurses refresh inputbox
        local user_input raw key char map append k
        local i_win=0
        append=false
        while true ; do
            zcurses input inputbox raw key
            if [[ -n $key ]] && [[ ${#user_input} -gt 0 ]] ; then
                case $key in
                    ('BACKSPACE')
                        if [[ $i_win -gt 0 ]] ; then
                            zcurses move inputbox 0 $((--i_win))
                            zcurses char inputbox ' '
                            zcurses move inputbox 0 $((i_win))
                            user_input[$i_win]=''
                        fi
                    ;;
                    ('LEFT')
                        if [[ $i_win -gt 0 ]] ; then
                            zcurses move inputbox 0 $((--i_win))
                        fi
                    ;;
                    ('RIGHT')
                        if [[ $i_win -lt ${#user_input} ]] ; then
                            zcurses move inputbox 0 $((++i_win))
                        fi
                    ;;
                esac
            else
                if [[ ${#user_input} -eq 38 ]] ; then
                    continue
                elif [[ $raw == $NEWLINE ]] ; then
                    break
                elif [[ -n $raw ]] ; then
                    if [[ $i_win == 0 ]] ; then
                        user_input="${raw}${user_input}"
                    else
                        user_input="${user_input[0, $((i_win-1))]}${raw}${user_input[$((i_win)),-1]}"
                    fi
                    ((i_win++))
                fi
            fi
            zcurses clear inputbox
            zcurses move inputbox 0 0
            zcurses string inputbox "$user_input"
            zcurses move inputbox 0 $i_win
            zcurses refresh inputbox
            unset raw key
        done
    } always {
        unsetopt ksharrays
        zcurses clear inputbox
        zcurses clear main
        zcurses refresh inputbox
        zcurses refresh main
        zcurses delwin inputbox
        zcurses delwin main
        zcurses end
        locate --database=$HOME/.locatedb "$user_input"
    }
}
