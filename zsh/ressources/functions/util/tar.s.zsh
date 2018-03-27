#!/usr/bin/zsh

tarxbz2 () {
    tar -xjvf "$@"
}

tarxgz () {
    tar -xzvf "$@"
}

tarcbz2 () {
    typeset OUTPUTFILE
    OUTPUTFILE=$1
    shift ;
    tar -jcvf $OUTPUTFILE.tar.bz2 $*
}

tarcgz () {
    typeset OUTPUTFILE
    OUTPUTFILE=$1
    shift ;
    tar -zcvf $OUTPUTFILE.tar.gz $*
}
