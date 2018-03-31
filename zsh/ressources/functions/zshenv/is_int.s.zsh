#!/usr/bin/zsh

## Check if arg is a number
is_int() {
    [[ "$1" = <-> ]] && return 0 || return 1
}
