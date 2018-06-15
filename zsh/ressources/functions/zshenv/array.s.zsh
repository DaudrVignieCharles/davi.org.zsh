#!/usr/bin/zsh

# find_item ITEM ITEMS
# Check if item is in items
find_item() {
    if [[ $# < 1 ]] ; then
        printf "find_item must have one argument.\n" >&2
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
        assert find_item ret "a a b c" 0
        assert find_item ret "a e b c" 1
        assert find_item ret "a" 1
    ) 1>>$ZTEST 2>&1
fi
