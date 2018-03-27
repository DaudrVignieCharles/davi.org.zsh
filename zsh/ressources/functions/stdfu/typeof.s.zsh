#!/usr/bin/zsh

typeof() {
    typeset varname
    varname=$1
    typeset str_eval
    str_eval="printf \"\${(t)$varname}\n\""
    typeset rep
    rep=$( eval "$str_eval" )
    if [[ -n "$rep" ]] ; then
        printf "type of \x1b[33;1m%s\x1b[0m is \x1b[1;31m%s\x1b[0m, it contain :\n\n%s\n" "$varname" "$rep" "$(eval "echo \$$varname")"
    else
        type $varname
    fi
}
