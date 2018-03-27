#!/usr/bin/zsh

# All normally formed IDEs automatically close the brackets and quotation marks.
# These widgets add this behavior for these keys: ( [ { "

# Advanced backward_kill_char: if deleted char is ( or [ of { or " and
# next char match with corresponding closure ( ) or ] or } ) the two will be deleted.
__zz_zle_backward_kill_char () {
    typeset CUR CURNEX PRE NEX
    CUR=$CURSOR
    [[ $CUR == 0 ]] && return
    CURNEX=$((CUR+1))
    PRE=$BUFFER[$CUR]
    NEX=$BUFFER[$CURNEX]
    if [[ $#BUFFER != $CUR ]] ; then
        (( CURSOR-- ))
    fi
    if [[ $PRE == '(' ]] && [[ $NEX == ')' ]] ; then
        BUFFER[$CURNEX]=''
    fi
    if [[ $PRE == '[' ]] && [[ $NEX == ']' ]] ; then
        BUFFER[$CURNEX]=''
    fi
    if [[ $PRE == '{' ]] && [[ $NEX == '}' ]] ; then
        BUFFER[$CURNEX]=''
    fi
    if [[ $PRE == '"' ]] && [[ $NEX == '"' ]] ; then
        BUFFER[$CURNEX]=''
    fi
    BUFFER[$CUR]=''
}
zle -N __zz_zle_backward_kill_char
bindkey "^?" __zz_zle_backward_kill_char

__zz_zle_symclose_roundbracket () {
    __zz_zle_gen_insert +1 "()"
}
zle -N __zz_zle_symclose_roundbracket
bindkey "(" __zz_zle_symclose_roundbracket

__zz_zle_symclose_squarebracket () {
    __zz_zle_gen_insert +1 "[]"
}
zle -N __zz_zle_symclose_squarebracket
bindkey "[" __zz_zle_symclose_squarebracket

__zz_zle_symclose_bracebracket () {
    __zz_zle_gen_insert +1 "{}"
}
zle -N __zz_zle_symclose_bracebracket
bindkey "{" __zz_zle_symclose_bracebracket

__zz_zle_symclose_quote () {
    __zz_zle_gen_insert +1 "\"\""
}
zle -N __zz_zle_symclose_quote
bindkey "\"" __zz_zle_symclose_quote

