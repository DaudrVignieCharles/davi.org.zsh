#!/usr/bin/zsh

## Check if arg is a number
is_int() {
    [[ "$1" = <-> ]] && return 0 || return 1
}

ztest is_int ret 1 0 >> $ZTEST
ztest is_int ret a 1 >> $ZTEST
