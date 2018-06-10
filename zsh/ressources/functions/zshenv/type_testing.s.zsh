#!/usr/bin/zsh

isuint(){
    [[ "$1" == <-> ]] && return 0 || return 1    
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
        assert isuint ret +123 1
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
