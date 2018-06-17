#!/usr/bin/zsh

# finditem ITEM ITEMS
# Check if item is in items
finditem() {
    if [[ $# < 1 ]] ; then
        printf "finditem must have one argument.\n" >&2
        return 2
    elif [[ $# -eq 1 ]] ; then
        return 1
    fi
    item=$1
    shift
    items=($@)
    if [[ ${items[(r)$item]} == $item ]] then return 0 ; else return 1 ; fi
}

if $ZUNITTEST ; then
    (
        assert finditem ret "a a b c" 0
        assert finditem ret "a e b c" 1
        assert finditem ret "a" 1
    ) 1>>$ZTEST 2>&1
fi
