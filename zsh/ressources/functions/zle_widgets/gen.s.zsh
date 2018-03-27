#!/usr/bin/zsh

# fu $MVCURSOR (+x|-x|=) $INS_STR
__zz_zle_gen_insert(){
    typeset MV_CURSOR INS_STR BEGIN END
    MV_CURSOR=$1
    INS_STR=$2
    BEGIN=$BUFFER[1,$CURSOR] 
    END=$BUFFER[$((CURSOR+1)),-1] 
    BUFFER="${BEGIN}${INS_STR}${END}" 
    if [[ "$MV_CURSOR" == "=" ]] ; then
        return 0
    else
        CURSOR=$(( $CURSOR $MV_CURSOR ))
    fi
} 
