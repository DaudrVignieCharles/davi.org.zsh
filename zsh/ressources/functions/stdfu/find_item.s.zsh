#!/usr/bin/zsh

# find_item ITEM ITEMS
# Check if item is in items
find_item() {
    item=$1
    shift
    items=($@)
    if [[ ${items[(r)$item]} == $item ]] then return 0 ; else return 1 ; fi
}
