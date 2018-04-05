#!/usr/bin/zsh

__zz_zle_gen_git-tui_add(){
    color_ok(){
        local color
        [[ $1 == '-u' ]] && { color=black/cyan attr=-bold } || { color=yellow/blue attr=+bold }
        zcurses attr ok $color $attr
        zcurses move ok 1 1
        zcurses string ok "OK"
        zcurses refresh ok
    }
    color_cancel(){
        local color
        [[ $1 == '-u' ]] && { color=black/cyan attr=-bold } || { color=yellow/blue attr=+bold }
        zcurses attr cancel $color $attr
        zcurses move cancel 1 1
        zcurses string cancel "Cancel"
        zcurses refresh cancel
    }
    clean_and_exit(){
        zcurses delwin ok
        zcurses delwin cancel
        zcurses delwin main
        zcurses end
        #clear
        NOEXIT=false
    }
    typeset -a GIT_ADD_LIST
    git_add(){
        local TOP_LEVEL="$(git rev-parse --show-toplevel)/"
        local i
        for (( i=1 ; i<=$Y_MAX ; i++)) ; do
            zcurses move main $i 3
            zcurses querychar main CHAR_ATTR
            if [[ $CHAR_ATTR[1] == '*' ]] ; then
                FILE=$FILES_STATUS[$((i))]
                FILE=( ${FILE:s/_/ } )
                GIT_ADD_LIST+=$TOP_LEVEL$FILE[2]
            fi
        done
    }
    #BEGIN INIT
    zmodload zsh/curses
    setopt shwordsplit
    setopt noksharrays
    zcurses init
    zcurses addwin main $LINES $COLUMNS 0 0
    zcurses scroll main on
    zcurses bg main cyan/cyan
    zcurses attr main black/cyan
    zcurses border main
    zcurses position main POS
    TITLE="┤ Cochez les fichiers à ajouter : ├"
    Y=0 X=$((COLUMNS/2-$#TITLE/2))
    zcurses move main $Y $X
    zcurses attr main black/cyan
    zcurses string main "$TITLE"
    Y=1 X=2
    #Button windows :
    zcurses addwin ok 3 4 $((LINES-4)) $((COLUMNS-16)) main
    zcurses border ok
    zcurses move ok 1 1
    zcurses string ok "OK"
    zcurses addwin cancel 3 8 $((LINES-4)) $((COLUMNS-10)) main
    zcurses border cancel
    zcurses move cancel 1 1
    zcurses string cancel "Cancel"
    BUTTON_STATE=none
    #END


    #BEGIN FILES TREATMENT
    typeset -a FILES_STATUS
    local i=0
    git status --porcelain | while read FILE_STATUS ; do
        ((i++))
        FILE_STATUS=( $FILE_STATUS )
        case $FILE_STATUS[1] in
            'MM')
                FILES_STATUS[$i]="$FILE_STATUS[1]_$FILE_STATUS[2]"
            ;;
            'AM')
                FILES_STATUS[$i]="$FILE_STATUS[1]_$FILE_STATUS[2]"
            ;;
            'AD')
                FILES_STATUS[$i]="$FILE_STATUS[1]_$FILE_STATUS[2]"
            ;;
            '??')
                FILES_STATUS[$i]="$FILE_STATUS[1]_$FILE_STATUS[2]"
            ;;
            'D')
                FILES_STATUS[$i]="$FILE_STATUS[1]_$FILE_STATUS[2]"
            ;;
            'M')
                FILES_STATUS[$i]="$FILE_STATUS[1]_$FILE_STATUS[2]"
            ;;
        esac
    done

    if ! [[ -n $FILES_STATUS ]] ; then
        clean_and_exit
        printf "\x1b[1;31mNothing can be added, no changes was found.\x1b[0m\n"
        return 0
    fi

    local FILE_LENGHT
    for FILE_STATUS in $FILES_STATUS ; do
        zcurses move main $((Y++)) $X
        zcurses string main "[ ] ${FILE_STATUS:s/_/ }"
        ((FILE_LENGHT++))
    done
    #BEGIN FILES TREATMENT

    Y_MIN=1
    Y_MAX=$(( FILE_LENGHT ))

    zcurses move main 1 3
    Y=1
    X=3
    zcurses refresh main
    NOEXIT=true
    while $NOEXIT ; do
        zcurses refresh main
        zcurses input main RAW KEY
        if [[ -n $RAW ]] ; then
            CHAR=$RAW
        else
            CHAR=$KEY
        fi
        X=3
        case $CHAR in
            $'\n')
                case $BUTTON_STATE in
                    'none')
                        :
                    ;;
                    'ok')
                        git_add
                        git add $GIT_ADD_LIST
                        clean_and_exit
                    ;;
                    'cancel')
                        clean_and_exit
                    ;;
                esac
            ;;
            'Q'|'q')
                clean_and_exit
            ;;
            'UP')
                color_ok -u
                color_cancel -u
                BUTTON_STATE=none
                if [[ $Y -eq $Y_MIN ]] ; then
                    zcurses move main $((Y=Y_MAX)) $X
                else
                    zcurses move main $((--Y)) $X
                fi
            ;;
            'DOWN')
                color_ok -u
                color_cancel -u
                BUTTON_STATE=none
                if [[ $Y -eq $Y_MAX ]] ; then
                    zcurses move main $((Y=1)) $X
                else
                    zcurses move main $((++Y)) $X
                fi
            ;;
            'LEFT')
                if [[ $BUTTON_STATE == none ]] || [[ $BUTTON_STATE == cancel ]] ; then
                    color_ok
                    color_cancel -u
                    BUTTON_STATE=ok
                elif [[ $BUTTON_STATE == ok ]] ; then
                    color_ok -u
                    color_cancel
                    BUTTON_STATE=cancel
                fi
            ;;
            'RIGHT')
                if [[ $BUTTON_STATE == none ]] || [[ $BUTTON_STATE == ok ]] ; then
                    color_ok -u
                    color_cancel
                    BUTTON_STATE=cancel
                elif [[ $BUTTON_STATE == cancel ]] ; then
                    color_ok
                    color_cancel -u
                    BUTTON_STATE=ok
                fi
            ;;
            ' ')
                zcurses querychar main CHAR_ATTR
                if [[ $CHAR_ATTR[1] == ' '  ]] ; then
                    zcurses char main '*'
                    zcurses move main $Y $X
                elif [[ $CHAR_ATTR[1] == '*' ]] ; then
                    zcurses char main ' '
                    zcurses move main $Y $X
                fi
            ;;
        esac
    done
}
