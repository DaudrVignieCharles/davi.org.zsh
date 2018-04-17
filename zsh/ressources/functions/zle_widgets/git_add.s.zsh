__zz_zle_git-tui_add(){

    init(){
        zmodload zsh/curses
        setopt shwordsplit
        setopt ksharrays
        zcurses init
        get_git_files
        init_main_window
        init_files_window
        # Init ok and cancel button
        zcurses addwin ok 3 4 $((LINES-4)) $((COLUMNS-16)) main
        set_button ok -u
        zcurses addwin cancel 3 8 $((LINES-4)) $((COLUMNS-10)) main
        set_button cancel -u
    }

    init_main_window(){
        zcurses addwin main $LINES $COLUMNS 0 0
        zcurses bg main cyan/cyan
        zcurses attr main black/cyan
        zcurses border main
        zcurses position main POS
        local title="┤ Cochez les fichiers à ajouter : ├"
        Y=0 X=$((COLUMNS/2-$#title/2))
        zcurses move main $Y $X
        zcurses attr main black/cyan
        zcurses string main "$title"
    }

    init_files_window(){
        # 5 -> 2+3 -> 2 for border, 3 for button at bottom
        if [[ $FILES_ALL_LEN -gt $((LINES-5)) ]] ; then
            WINDOW_LEN=$((LINES-5))
        else
            WINDOW_LEN=$((FILES_ALL_LEN))
        fi
        zcurses addwin files $((WINDOW_LEN)) $((COLUMNS-5)) 1 1 main
        zcurses bg files black/cyan
        zcurses scroll files on
        zcurses refresh files
    }

    set_button(){ # $1= cancel ok none
        local button=$1
        local color
        case $button in
            "ok")
                str="OK"
            ;;
            "cancel")
                str="Cancel"
            ;;
        esac
        if [[ $2 == '-u' ]] ; then
            color=black/cyan attr=-bold
        else
            color=yellow/blue attr=+bold
        fi
        zcurses bg $button $color
        zcurses border $button
        zcurses attr $button $color $attr
        zcurses move $button 1 1
        zcurses string $button "$str"
        zcurses refresh $button
    }

    reset_buttons(){
        case $BUTTON_STATE in
            "none")
                :
            ;;
            "ok")
                set_button ok -u
                BUTTON_STATE=none
            ;;
            "cancel")
                set_button cancel -u
                BUTTON_STATE=none
            ;;
        esac
    }

    get_git_files(){
        local list file_status
        local i=0
        list=$(git status --porcelain | tr '\n' '*')
        IFS="*"
        for file_status in $list ; do
            case "${file_status[0]}${file_status[1]}" in
                'MM')
                    FILES_ALL[$i]="${file_status[0,1]}_${file_status[3,-1]}" && ((i++))
                ;;
                'AM')
                    FILES_ALL[$i]="${file_status[0,1]}_${file_status[3,-1]}" && ((i++))
                ;;
                'AD')
                    FILES_ALL[$i]="${file_status[0,1]}_${file_status[3,-1]}" && ((i++))
                ;;
                '??')
                    FILES_ALL[$i]="${file_status[0,1]}_${file_status[3,-1]}" && ((i++))
                ;;
                ' D')
                    FILES_ALL[$i]="${file_status[0,1]}_${file_status[3,-1]}" && ((i++))
                ;;
                ' M')
                    FILES_ALL[$i]="${file_status[0,1]}_${file_status[3,-1]}" && ((i++))
                ;;
            esac
        done
        unset IFS
        export FILES_ALL_LEN=${#FILES_ALL[@]}
        if ! [[ -n ${FILES_ALL[@]} ]] ; then
            printf "\x1b[1;31mNothing can be added, no changes was found.\x1b[0m\n"
            return 0
        fi
    }

    print_line(){
        local line="$1"
        if [[ -n ${FILES_ADD[(r)$line]} ]] ; then
            zcurses string files "[*] ${line:s/_/ }"
        else
            zcurses string files "[ ] ${line:s/_/ }"
        fi
    }

    FILES_ADD.append(){
        local indice=$1
        FILES_ADD+=(${FILES_ALL[$indice]})
    }

    FILES_ADD.remove(){
        local string=$1
        local indice
        indice=${FILES_ALL[(i)$string]}
        FILES_ALL[$indice]=()
    }

    print_first_lines(){
        local file
        local i
        WINDOW_CURSOR=0
        for ((i=0 ; i<=FILES_ALL_LEN ; i++)) ; do
            file=${FILES_ALL[$i]}
            zcurses move files $((WINDOW_CURSOR++)) 0
            print_line "$file"
            if [[ $WINDOW_CURSOR -eq $WINDOW_LEN ]] ; then
                break
            fi
        done
        WINDOW_CURSOR=0
        FILES_CURSOR=0
        zcurses move files 0 1
    }

    print_last_lines(){
        local file
        local i i_base
        WINDOW_CURSOR=0
        i_base=$(( FILES_ALL_LEN - WINDOW_LEN ))
        for ((i=i_base ; i<=FILES_ALL_LEN-1 ; i++ )) ; do
            file=${FILES_ALL[$i]}
            zcurses move files $((WINDOW_CURSOR++)) 0
            print_line "$file"
        done
    }

    wait_for_user_keypress(){
        local string
        local raw key char
        X=1
        zcurses refresh files
        # User can press two types of key :
        # RAW (classic alpha-num-sym) and KEY (special key like the arrow keys)
        # whatever the type of key, it will be placed in CHAR
        zcurses input files raw key
        if [[ -n $raw ]] ; then
            char=$raw
        else
            char=$key
        fi
        case $char in
            $'\n')
                case $BUTTON_STATE in
                    'none')
                        :
                    ;;
                    'ok')
                        (){
                            local file
                            typeset -a the_end
                            for file in ${FILES_ADD[@]} ; do
                                file=( ${file:s/_/ } )
                                the_end+=(${file[1]})
                            done
                            git add ${the_end[@]}
                        }
                        #git add $GIT_ADD_LIST
                        NOEXIT=false
                    ;;
                    'cancel')
                        NOEXIT=false
                    ;;
                esac
            ;;
            'Q'|'q')
                NOEXIT=false
            ;;
            'UP')
                reset_buttons
                if [[ $WINDOW_CURSOR -eq 0 ]] ; then
                    if [[ $WINDOW_LEN -ge $FILES_ALL_LEN ]] && [[ $FILES_CURSOR -eq 0 ]] ; then
                        zcurses move files $((WINDOW_LEN-1)) 1
                        FILES_CURSOR=$((FILES_ALL_LEN-1))
                        WINDOW_CURSOR=$((WINDOW_LEN-1))
                    elif [[ $WINDOW_LEN -lt $FILES_ALL_LEN ]] && [[ $FILES_CURSOR -ne 0 ]] ; then
                        zcurses scroll files -1
                        zcurses refresh files
                        string=${FILES_ALL[$((--FILES_CURSOR))]}
                        zcurses move files 0 0
                        print_line "$string"
                        zcurses move files 0 1
                        zcurses refresh files
                    else
                        zcurses move files 0 0
                        zcurses clear files
                        print_last_lines
                        FILES_CURSOR=$((FILES_ALL_LEN-1))
                        WINDOW_CURSOR=$((WINDOW_LEN-1))
                        zcurses move files $WINDOW_CURSOR 1
                        zcurses refresh files
                    fi
                else
                    zcurses move files $((--WINDOW_CURSOR)) $X
                    ((--FILES_CURSOR))
                fi
            ;;
            'DOWN')
                reset_buttons
                if [[ $WINDOW_CURSOR -eq $WINDOW_LEN-1 ]] ; then
                    if [[ $FILES_ALL_LEN-1 -gt $FILES_CURSOR ]] ; then
                        zcurses scroll files +1
                        zcurses refresh files
                        string=${FILES_ALL[$((++FILES_CURSOR))]}
                        zcurses move files $((WINDOW_LEN-1)) 0
                        print_line "$string"
                        zcurses move files $((WINDOW_LEN-1)) 1
                        zcurses refresh files
                    else
                        WINDOW_CURSOR=0
                        FILES_CURSOR=0
                        zcurses move files 0 0
                        zcurses clear files
                        print_first_lines
                        zcurses refresh files
                    fi
                else
                    zcurses move files $((++WINDOW_CURSOR)) $X
                    ((FILES_CURSOR++))
                fi
            ;;
            'LEFT')
                if [[ $BUTTON_STATE == none ]] || [[ $BUTTON_STATE == cancel ]] ; then
                    set_button ok
                    set_button cancel -u
                    BUTTON_STATE=ok
                elif [[ $BUTTON_STATE == ok ]] ; then
                    set_button ok -u
                    set_button cancel
                    BUTTON_STATE=cancel
                fi
            ;;
            'RIGHT')
                if [[ $BUTTON_STATE == none ]] || [[ $BUTTON_STATE == ok ]] ; then
                    set_button ok -u
                    set_button cancel
                    BUTTON_STATE=cancel
                elif [[ $BUTTON_STATE == cancel ]] ; then
                    set_button ok
                    set_button cancel -u
                    BUTTON_STATE=ok
                fi
            ;;
            ' ')
                if [[ $BUTTON_STATE != "none" ]] ; then
                    return 0
                fi
                zcurses querychar files CHAR_ATTR
                if [[ ${CHAR_ATTR[0]} == ' '  ]] ; then
                    zcurses char files '*'
                    zcurses move files $WINDOW_CURSOR $X
                    FILES_ADD.append $FILES_CURSOR
                elif [[ ${CHAR_ATTR[0]} == '*' ]] ; then
                    zcurses char files ' '
                    zcurses move files $WINDOW_CURSOR $X
                    FILES_ADD.remove ${FILES_ADD[$FILES_CURSOR]}
                fi
            ;;
        esac
    }
    {
        # BUTTON_STATE can have three states: none, ok, cancel
        # none: focused on no button
        # ok: focused on the ok button
        # cancel: focused on the cancel button
        typeset -g BUTTON_STATE=none
        typeset -ga FILES_ALL
        typeset -g FILES_ALL_LEN
        typeset -ga FILES_ADD
        typeset -g FILES_CURSOR=0
        typeset -g WINDOW_CURSOR=0
        typeset -g WINDOW_LEN
        typeset -g NOEXIT=true
        init
        print_first_lines
        zcurses refresh main
        zcurses refresh files
        while $NOEXIT ; do
            wait_for_user_keypress
        done
    } always {
        zcurses delwin files
        zcurses delwin ok
        zcurses delwin cancel
        zcurses delwin main
        zcurses end
        for file in ${FILES_ADD[@]} ; do echo "file added : ${file[3,-1]} (${file[0,1]})" ; done
        unset BUTTON_STATE FILES_ALL FILES_ALL_LEN
        unset FILES_ADD FILES_CURSOR WINDOW_CURSOR
        unset WINDOW_LEN NOEXIT
        unsetopt ksharrays
    }

}
