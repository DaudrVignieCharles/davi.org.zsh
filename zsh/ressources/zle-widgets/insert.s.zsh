#!/usr/bin/zsh

### printf
__zz_zle_insert_printf () {
     __zz_zle_gen_insert +8 "printf \"\n\""
}
zle -N __zz_zle_insert_printf
bindkey "^[!^[e" __zz_zle_insert_printf

### if
__zz_zle_insert_if () {
    local STR=$(<<EOF
if  ; then
    
fi
EOF
    )
    __zz_zle_gen_insert +3 $STR
}
zle -N __zz_zle_insert_if
bindkey "^[!^[i" __zz_zle_insert_if

### while
__zz_zle_insert_while () {
    local STR=$(<<EOF
while  ; do
    
done
EOF
    )
    __zz_zle_gen_insert +6 $STR
}
zle -N __zz_zle_insert_while
bindkey "^[!^[w" __zz_zle_insert_while

### for
__zz_zle_insert_for () {
    local STR=$(<<EOF
for  ; do
    
done
EOF
    )
    __zz_zle_gen_insert +4 $STR
}
zle -N __zz_zle_insert_for
bindkey "^[!^[f" __zz_zle_insert_for

__zz_zle_insert_case () {
    local STR=$(<<EOF
case  in
    "")
    ;;
    "")
    ;;
esac
EOF
    )
    __zz_zle_gen_insert +5 $STR
}
zle -N __zz_zle_insert_case
bindkey "^[!^[c" __zz_zle_insert_case

### for
__zz_zle_insert_function () {
    local STR=$(<<EOF
 () {
    
}
EOF
    )
    __zz_zle_gen_insert = $STR
}
zle -N __zz_zle_insert_function
bindkey "^[!^[(" __zz_zle_insert_function

