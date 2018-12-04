#!/usr/bin/zsh

# TYPE : CHARACTER
typeset -a lCharMap ;
lCharMap=(a b c d e f g h i j k l m n o p q r s t u v w x y z) ;
#typeset -gr lCharMap ;
typeset -a uCharMap ;
uCharMap=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) ;
#typeset -gr uCharMap ;
typeset -a numMap ;
numMap=(0 1 2 3 4 5 6 7 8 9) ;
#typeset -gr numMap ;
typeset -a charExt64Map ;
charExt64Map=("+" "/") ;
#typeset -gr charExt64Map ;
typeset -a base64CharMap ;
base64CharMap=(${uCharMap[@]} ${lCharMap[@]} ${numMap[@]} ${charExt64Map[@]});
#typeset -gr base64CharMap ;

# TYPE : ARRAY

# finditem ITEM ITEMS
# Check if item is in items
finditem() {
    if [[ $# < 1 ]] ; then
        printf "finditem must have one argument.\n" >&2 ;
        return 2
    elif [[ $# -eq 1 ]] ; then
        return 1
    fi
    typeset item ;
    item=$1 ;
    shift ;
    items=($@) ;
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


# TYPE : NUMERIC BIN

isbin(){
    [[ -z "$1" ]] && return 1
    [[ "$1" =~ "^[01]*$" ]] && return 0 || return 1
}

# TYPE : NUMERIC OCT

isoct(){
    [[ -z "$1" ]] && return 1
    [[ "$1" =~ "^[0-8]*$" ]] && return 0 || return 1
}

# TYPE : NUMERIC HEX

ishex(){
    [[ -z "$1" ]] && return 1
    [[ "$1" =~ "^[0-9a-fA-F]*$" ]] && return 0 || return 1
}

# TYPE : NUMERIC 10

isuint(){
    [[ -z "$1" ]] && return 1
    [[ "$1" =~ "^\+?[0-9]*$" ]] && return 0 || return 1
}

isint(){
    [[ -z "$1" ]] && return 1
    [[ "$1" =~ "^[+-]?[0-9]*$" ]] && return 0 || return 1
}

isufloat(){
    [[ -z "$1" ]] && return 1
    [[ "$1" =~ "^[0-9]*\.[0-9]*$" ]] && return 0 || return 1
}

isfloat(){
    [[ -z "$1" ]] && return 1
    [[ "$1" =~ "^[+-]?[0-9]*\.[0-9]*$" ]] && return 0 || return 1
}

isnumber(){
    [[ -z "$1" ]] && return 1
    [[ "$1" =~ "^[+-]?[0-9]*(\.[0-9]*)?$" ]] && return 0 || return 1
}

# TYPE : NUMERIC CONVERT

__zz_env_libtype_dec2base(){
    typeset nu ;
    nu="$1" ;
    typeset endu ;
    endnu="" ;
    typeset mod ;
    typeset base ;
    base=$2 ;
    if isuint "$nu" ; then
        if ! isuint "$base" ; then
            printf "decAsBase : error : base must be an unsigned integer\n" ;
            return 1
        fi
        if [[ $base -gt 9 ]] && [[ $base -ne 16 ]] ; then
            printf "decAsBase : error : base cant be greater than 9 except for base 16\n" ;
            return 1
        fi
        while [[ $nu -gt 0 ]] ; do
            mod=$((nu%base)) ;
            nu=$((nu/base)) ;
            if [[ $base -eq 16 ]] ; then
                case $mod in
                    10) mod="a"
                    ;;
                    11) mod="b"
                    ;;
                    12) mod="c"
                    ;;
                    13) mod="d"
                    ;;
                    14) mod="e"
                    ;;
                    15) mod="f"
                    ;;
                esac
            fi
            endnu+="$mod" ;
        done
        for ((i=$#endnu ; i>=0 ; i--)) ; do
            printf "%s" "$endnu[$i]" ;
        done
        printf "\n" ;
        return 0
    else
        printf "decAsBase : error : origin number must be an unsigned integer\n" ;
        return 1 ;
    fi
}

__zz_env_libtype_base2dec(){
    typeset nu ;
    nu="$1" ;
    typeset swp ;
    typeset -i endnu ;
    endnu=0 ;
    typeset base ;
    base=$2 ;
    typeset i ;
    typeset n ;
    n=0 ;
    if isuint "$nu" || ishex "$base" ; then
        if ! isuint "$base" ; then
            printf "baseAsDec : error : base must be an unsigned integer\n" ;
            return 1
        fi
        if [[ $base -gt 9 ]] && [[ $base -ne 16 ]] ; then
            printf "baseAsDec : error : base cant be greater than 9 except for base 16\n" ;
            return 1
        fi
        for ((i=$#nu ; i>0 ; i--)) ; do
            swp=$nu[$i] ;
            if [[ $base -eq 16 ]] ; then
                case $swp in
                    "a"|"A") swp="10"
                    ;;
                    "b"|"B") swp="11"
                    ;;
                    "c"|"C") swp="12"
                    ;;
                    "d"|"D") swp="13"
                    ;;
                    "e"|"E") swp="14"
                    ;;
                    "f"|"F") swp="15"
                    ;;
                esac
            fi
            if [[ $swp -ge $base ]] ; then
                printf "baseAsDec : error : operand part \"%d\" is greater or equal to base %d\n" "$nu[$i]" "$base" ;
                return 1 ;
            fi
            ((endnu+=( swp*(base**n) ) , n++)) ;
        done
        printf "%s\n" "$endnu" ;
    else
        return 1
    fi
}

zz.bin2dec(){

    __zz_env_libtype_base2dec $1 2
}

zz.oct2dec(){
    __zz_env_libtype_base2dec $1 8
}

zz.hex2dec(){
    __zz_env_libtype_base2dec $1 16
}

zz.dec2bin(){
    __zz_env_libtype_dec2base $1 2
}

zz.dec2oct(){
    __zz_env_libtype_dec2base $1 8
}

zz.dec2hex(){
    __zz_env_libtype_dec2base $1 16
}

# TYPE : BOOLEAN OP

binOp(){
    typeset res ;
    typeset swp ;
    typeset operator ;
    typeset i ;
    operator=$1 ;
    shift ;
    case $operator in
        'not'|'comp2')
            typeset operand ;
            operand=$1 ;
            if ! isbin $operand ; then
                printf "not : error : %s can not be recognized as an unsigned binary integer\n" "$op" ;
                return 1
            fi
            case $operator in
                'not')
                    for ((i=1 ; i<=$#op ; i++)) ; do
                        if [[ $op[$i] -eq 1 ]] ; then
                            res+=0 ;
                        elif [[ $op[$i] -eq 0 ]] ; then
                            res+=1 ;
                        fi
                    done
                ;;
                'comp2')
                ;;
            esac
        ;;
        'and'|'or'|'xor'|'shiftl'|'shiftr')
            typeset operand1 ;
            operand1=$1 ;
            typeset operand2 ;
            operand2=$2 ;
            if ! isbin $operand1 ; then
                printf "bool : error : %s can not be recognized as an unsigned binary integer\n" "$operand1" ;
                return 1
            fi
            case $operator in
                'shiftl'|'shiftr')
                    if [[ -z $operand2 ]] ; then
                        operand2=1 ;
                    fi
                    if ! isuint $operand2 ; then
                printf "bool : error : %s can not be recognized as an unsigned decimal integer\n" "$operand2" ;
                    fi
                    case $operator in
                        'shiftl')
                            for ((i=1 ; i<=$#operand2 ; i++)) ; do
                                operand1[1]="" ;
                                operand1[$(($#operand1))+1]="0" ;
                            done
                        ;;
                        'shiftr')
                            for ((i=1 ; i<=$#operand2 ; i++)) ; do
                                operand1[$#operand1]="" ;
                                operand1="0$operand1" ;
                            done
                        ;;
                    esac
                    res=$operand1 ;
                ;;
                'and'|'or'|'xor')
                    if [[ $# -ne 2 ]] ; then
                        printf "bool : error : %s must have two operands\n" "$operator";
                        return 1
                    fi
                    if ! isbin $operand2 ; then
                        printf "bool : error : %s can not be recognized as an unsigned binary integer\n" "$operand2" ;
                        return 1
                    fi
                    if [[ $#operand1 -ne $#operand2 ]] ; then
                        printf "bool : error : %s must have two operands with the same lenght\n" "$operator" ;
                        return 1
                    fi
                    typeset -A opmap ;
                    opmap=(
                        'and' '001'
                        'or'  '011'
                        'xor' '010'
                    )
                    swp=$opmap[$operator] ;
                    for ((i=1 ; i<=$#operand1 ; i++ )) ; do
                        if [[ $operand1[$i] -eq 0 ]] && [[ $operand2[$i]  -eq 0 ]] ; then
                            res+="$swp[1]" ;
                        elif { [[ $operand1[$i]  -eq 1 ]] && [[ $operand2[$i]  -eq 0 ]] } || { [[ $operand1[$i]  -eq 0 ]] && [[ $operand2[$i]  -eq 1 ]] } ; then
                            res+="$swp[2]" ;
                        elif [[ $operand1[$i]  -eq 1 ]] && [[ $operand2[$i]  -eq 1 ]] ; then
                            res+="$swp[3]" ;
                        fi
                    done
                ;;
            esac
        ;;
    esac
    printf "%s\n" "$res" ;
    return 0
}


not(){
    typeset op ;
    op=$1 ;
    typeset i ;
    if ! isbin $op ; then
        printf "not : error : %s can not be recognized as an unsigned binary integer\n" "$op" ;
        return 1
    fi
    for ((i=1 ; i<=$#op ; i++)) ; do
        if [[ $op[$i] -eq 1 ]] ; then
            op[$i]=0 ;
        elif [[ $op[$i] -eq 0 ]] ; then
            op[$i]=1 ;
        fi
    done
    printf "%d\n" "$op" ;
}

comp1(){

}

comp2(){

}

btwise(){

}

btsl(){

}

btsr(){

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
