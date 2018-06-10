#!/usr/bin/zsh

assert inexistant out '==' 'hello' 'hello'

fu(){echo "$@"}
assert fu out '==' "hello" "hello"
assert fu ou '==' "hello" "hello"
assert fu out '+=' "hello" "hello"

carre(){ echo $(($1*$1)) }
assert carre out '-eq' 0 0
assert carre out '-eq' 1 1
assert carre out '-eq' 2 4
assert carre out '-eq' 3 9
assert carre out '-eq' 2 5

test_is_int(){ [[ "$1" -eq "$1" ]] }
assert test_is_int ret 1 0
assert test_is_int ret 1.1 0
assert test_is_int ret -1.1 0
assert test_is_int ret a 1

