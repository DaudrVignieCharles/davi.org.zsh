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
