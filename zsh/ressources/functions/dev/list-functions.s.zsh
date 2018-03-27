#!/usr/bin/zsh

list-functions(){
    typeset -f | awk '!/^main[ (]/ && /^[^ {}]+ *\(\)/ { gsub(/[()]/, "", $1); print $1}' | egrep -v "^_."
}

