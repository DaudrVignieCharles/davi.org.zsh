#!/usr/bin/zsh


zz.dev.curses.inputbox(){
    {
        zparseopts h=HELP -help=HELP
        if [[ -n $HELP ]] ; then
            printf "zz.dev.curses.inputbox [uint COLUMNS]
Argument errors are silently processed by setting a default value dependent on the error.
"
            return 0
        fi
        NCOL=$1
        if [[ -z $NCOL ]] || ! isuint $NCOL ; then
            NCOL=40
        elif [[ $NCOL -lt 4 ]] ; then
            NCOL=4
        elif [[ $NCOL -gt $COLUMNS ]] ; then
            NCOL=$COLUMNS
        fi
        zmodload -e zsh/curses || zmodload zsh/curses
        setopt ksharrays
        zcurses init
        zcurses addwin main 3 $NCOL $((LINES/2-2)) $((COLUMNS/2-$NCOL/2))
        zcurses attr main white/black
        zcurses border main
        zcurses addwin inputbox 1 $((NCOL-2)) $((LINES/2-1)) $(( COLUMNS/2-(NCOL/2-1) )) main
        zcurses attr inputbox white/black
        zcurses move inputbox 0 0
        zcurses refresh main
        zcurses refresh inputbox
        local user_input raw key
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
                if [[ $raw == $NEWLINE ]] ; then
                    break
                elif [[ ${#user_input} -eq $((NCOL-3)) ]] ; then
                    continue
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
        if [[ $TRY_BLOCK_ERROR -ne 0 ]] ; then
            unsetopt ksharrays
            zcurses clear inputbox
            zcurses clear main
            zcurses refresh inputbox
            zcurses refresh main
            zcurses delwin inputbox
            zcurses delwin main
            zcurses end
            if [[ -n $user_input ]] ; then
                printf "%s\n" "$user_input" >&2
            fi
        fi
    }
} 3>&1 1>&2 2>&3
