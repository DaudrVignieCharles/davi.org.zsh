#!/usr/bin/zsh

# TYPE : ARRAY

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
    if [[ ${items[(r)$item]} == $item ]] ; then
        return 0
    else
        return 1
    fi
}

if $ZUNITTEST ; then
    (
        assert finditem ret "a a b c" 0
        assert finditem ret "a e b c" 1
        assert finditem ret "a" 1
    ) 1>>$ZTEST 2>&1
fi

# TYPE : NUMERIC

isuint(){
    [[ "$1" =~ "^\+?[0-9]*$" ]] && return 0 || return 1
}

isint(){
    [[ "$1" =~ "^[+-]?[0-9]*$" ]] && return 0 || return 1
}

isufloat(){
    [[ "$1" =~ "^[0-9]*\.[0-9]*$" ]] && return 0 || return 1
}

isfloat(){
    [[ "$1" =~ "^[+-]?[0-9]*\.[0-9]*$" ]] && return 0 || return 1
}

isnumber(){
    [[ -z "$1" ]] && return 1
    [[ "$1" =~ "^[+-]?[0-9]*(\.[0-9]*)?$" ]] && return 0 || return 1
}

if $ZUNITTEST ; then
    (
        assert isuint ret "a" 1
        assert isuint ret 1 0
        assert isuint ret 123 0
        assert isuint ret -123 1
        assert isuint ret +123 0
        assert isuint ret 123.123 1
        assert isuint ret .1 1
        assert isuint ret 123. 1

        assert isint ret "a" 1
        assert isint ret 1 0
        assert isint ret 123 0
        assert isint ret -123 0
        assert isint ret +123 0
        assert isint ret 123.123 1
        assert isint ret .1 1
        assert isint ret 123. 1

        assert isufloat ret "a" 1
        assert isufloat ret 1 1
        assert isufloat ret 123 1
        assert isufloat ret -123 1
        assert isufloat ret +123 1
        assert isufloat ret 123.123 0
        assert isufloat ret -123.123 1
        assert isufloat ret +123.123 1
        assert isufloat ret .1 0
        assert isufloat ret 123. 0

        assert isfloat ret "a" 1
        assert isfloat ret 1 1
        assert isfloat ret 123 1
        assert isfloat ret -123 1
        assert isfloat ret +123 1
        assert isfloat ret 123.123 0
        assert isfloat ret -123.123 0
        assert isfloat ret +123.123 0
        assert isfloat ret .1 0
        assert isfloat ret 123. 0

        assert isnumber ret "a" 1
        assert isnumber ret 1 0
        assert isnumber ret 123 0
        assert isnumber ret -123 0
        assert isnumber ret +123 0
        assert isnumber ret 123.123 0
        assert isnumber ret -123.123 0
        assert isnumber ret +123.123 0
        assert isnumber ret .1 0
        assert isnumber ret 123. 0
    ) 1>>$ZTEST
fi
