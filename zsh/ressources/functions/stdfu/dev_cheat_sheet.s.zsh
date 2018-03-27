#!/usr/bin/zsh

dev_cheat_sheet() {
    cat<<'EOF'
${x:='Hello'}  --> if x is not set, set x to hello
echo ${a:0:3}  --> return 3 first char of variable a
printf "${(t)fpath}\n"  --> return type of fpath variable
printf "${list:t}\n"  --> return basename of path in list
printf "${list:h}\n"  --> return dirname of path in list

(( $+var )) like [[ -n var ]]

Syntax : ${x:y} --> use it if x is a variable
Syntax : x(:y) --> use it if x is a string
Syntax : $x(:y) if x is a variable
:t --> basename
:r --> remove extention
:e --> extention
:h --> parent of file
:h:h --> parent of the parent
:u --> uppercase
:l --> lowercase
${var:s/xx/yy} --> substitute xx by yy in var
:g --> global, apply other modifier for each patern
${(s/_/)my_string} --> split my_string on _ character
${(j/-/)my_array} --> unsplit my_array with - character
${myvar:Q} --> strip first and last quote in myvar
EOF
}
