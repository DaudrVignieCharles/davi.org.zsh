#!/usr/bin/zsh

zfilemode(){
    zmodload zsh/regex
    HELP="zfilemode -[rodhb] FILE
Print filemode of FILE in octal without argument, else :
    -r : raw
    -d : decimal
    -h : hexadecimal
    -b : binary"

    if ! [[ -n $@ ]] || [[ $#@ -gt 2 ]]; then
        printf "%s\n" "$HELP"
        return 1
    fi
    if [[ $#@ == 1 ]] ; then
        ARG=-o
        FILE=$1
    elif [[ $#@ == 2 ]] ; then
        ARG=$1
        FILE=$2
    fi
    typeset -i 8 MODE
    [[ $(zstat -o $FILE) -regex-match "mode[[:blank:]]*[0-8]{4}([0-8]{3})" ]] && MODE=8#$match || return 1
    case $ARG in
        ('-o') printf "%s\n" "$MODE[3,-1]"
        ;;
        ('-r') [[ $(zstat -s $FILE) -regex-match "mode[[:blank:]]*(.{10})" ]] && echo $match || return 1
        ;;
        ('-d') typeset -i 10 MODE && printf "%s\n" "$MODE"
        ;;
        ('-h') typeset -i 16 MODE && printf "%s\n" "$MODE[4,-1]"
        ;;
        ('-b') typeset -i 2 MODE && printf "%s\n" "$MODE[3,-1]"
        ;;
        *) printf "$ARG : Unknown argument.\n" && return 1
        ;;
    esac
}
