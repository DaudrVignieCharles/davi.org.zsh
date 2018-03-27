#!/usr/bin/zsh

ccompile(){
    source=$1;
    ctrl=$2
    shift;
    if ! [[ -n $source ]] ; then
        printf "Argument error.\n";
        return 1;
    fi
    if ! [[ -f $source ]] ; then
        printf "%s is not a standard file or does not exist.\n" "$source";
        return 1;
    fi
    if [[ $source[-2,-1] != ".c" ]]; then
        printf "%s does not appear to be a valid c file, valid c file must have \".c\" extension.\n" "$source";
        return 1;
    else
        case $ctrl in
            "strict") gcc $source -o $source[1,-3] -Wall -Wextra -std=c99 -g
            ;;
            '') gcc $source -o $source[1,-3] $@ ;
            ;;
        esac
    fi
}
