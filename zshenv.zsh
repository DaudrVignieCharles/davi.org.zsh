#!/usr/bin/zsh

export ZTEST="$HOME/.zsh_test.log"
fpath=($HOME/.zsh/ressources/autoload/**/*(/\N) $fpath)

assert(){
    {
        # HELP:
            # assert myfunction (out, err) test function_parameters expected_output
            # assert myfunction ret function_parameters expected_return_code
        # EX:
            # fu(){ echo "$1\n$2" }
            # myfunction(){ echo "$@" }
            # carre(){ echo $(( $1*$1 )) }
            # assert myfunction stderr '==' "hello world" "hello world"
            # assert myfunction stderr '==' "hello" "world" "hello${NEWLINE}world"
            # assert carre stderr '-eq' "2" "4"
            # assert true ret "" 0
            # assert false ret "" 1
        setopt shwordsplit
        local futype # type of drivefunction : zsh function or command or raise error
        local drivefunction="$1" # function name
        shift
        local fdreturn="$1" # out | err | ret (stdout, stderr, return code)
        shift
        typeset -a input # functions parameters
        typeset -a expected_output # expected result (function output, return code)
        local drivetest # test
        local real_output # real result (function output, return code)
        local err
        local ret
        local test_result

        futype=( $(whence -vw $drivefunction) )
        if [[ "${futype[2]}" == "command" ]] || [[ "${futype[2]}" == "function" ]] ; then
            :
        else
            printf "│\x1b[1;35m██\x1b[0m ztest: error while testing \"%s\":\n" "$drivefunction" 2>&1
            printf "│\x1b[1;35m██\x1b[0m \"%s\" not found in ZSH functions or in commands.\n" "$drivefunction" 2>&1
            printf "└─────────────────────────────────────────────────────────────────\n" 2>&1
            return 1
        fi
        if [[ "$fdreturn" == "ret" ]] ; then
            input=( ${@[1,-2]} )
            expected_output="$@[-1]"
            $drivefunction $input
            real_output=$?
            if [[ $real_output -ne $expected_output ]] ; then
                printf "│\x1b[1;31m██\x1b[0m ztest: return code of \"%s\":\n" "$drivefunction"  2>&1
                printf "│\x1b[1;31m██\x1b[0m assertion failure: %s -eq %s\n" "$expected_output" "$real_output" 2>&1
                printf "│\x1b[1;31m██\x1b[0m executed : %s %s --> %s\n" "$drivefunction" "$input" "$real_output"
                printf "│\x1b[1;31m██\x1b[0m expected : %s %s --> %s\n" "$drivefunction" "$input" "$expected_output"
                printf "└─────────────────────────────────────────────────────────────────\n" 2>&1
            else
                printf "│\x1b[1;32m██\x1b[0m ztest: return code of \"%s\" :\n" "$drivefunction" 2>&1
                printf "│\x1b[1;32m██\x1b[0m assertion success\x1b[0m: %s -eq %s\n" "$expected_output" "$real_output" 2>&1
                printf "│\x1b[1;32m██\x1b[0m executed : %s %s --> %s\n" "$drivefunction" "$input" "$real_output"
                printf "└─────────────────────────────────────────────────────────────────\n" 2>&1
            fi
            return 0
        fi
        drivetest="$1"
        shift
        input=()
        local i
        unsetopt shwordsplit
        for i in ${@[1,-2]} ; do
            input+="$i"
        done
        expected_output="$@[-1]"
        if [[ "$fdreturn" == "out" ]] ; then
            real_output=$($drivefunction ${input[@]}) 2>/dev/null
        elif [[ "$fdreturn" == "err" ]] ; then
            real_output=$($drivefunction ${input[@]} 2>&1 1>/dev/null)
        else
            printf "│\x1b[1;35m██\x1b[0m ztest: error while testing \"%s\":\n" "$drivefunction" 2>&1
            printf "│\x1b[1;35m██\x1b[0m invalid argument \"%s\": must be one of out|err|ret.\n" "$fdreturn" 2>&1
            printf "└─────────────────────────────────────────────────────────────────\n" 2>&1
            return 1
        fi
        local str_eval="[[ \"${expected_output}\" ${drivetest} \"${real_output}\" ]]"
        err=$(eval "$str_eval" 2>&1 )
        if [[ -n $err ]] ; then
            printf "│\x1b[1;35m██\x1b[0m ztest: error while testing \"%s\":\n" "$drivefunction" 2>&1
            printf "│\x1b[1;35m██\x1b[0m invalid test \"%s\".\n" "$drivetest" 2>&1
            printf "│\x1b[1;35m██\x1b[0m error :\n%s\n" "$err" 2>&1
            printf "└─────────────────────────────────────────────────────────────────\n" 2>&1
            return 1
        fi
        eval "$str_eval" 1>&2 2>/dev/null
        ret=$?
        case $ret in
            '0')
                printf "│\x1b[1;32m██\x1b[0m ztest: std$fdreturn of \"%s\":\n" "$drivefunction" 2>&1
                printf "│\x1b[1;32m██\x1b[0m assertion success : %s\n" "$str_eval" 2>&1
                printf "│\x1b[1;32m██\x1b[0m executed : %s %s --> %s\n" "$drivefunction" "$input" "$real_output"
                printf "└─────────────────────────────────────────────────────────────────\n" 2>&1
            ;;
            '1')
                printf "│\x1b[1;31m██\x1b[0m ztest: std$fdreturn of \"%s\":\n" "$drivefunction" 2>&1
                printf "│\x1b[1;31m██\x1b[0m assertion failure : %s\n" "$str_eval" 2>&1
                printf "│\x1b[1;31m██\x1b[0m executed : %s %s --> %s\n" "$drivefunction" "$input" "$real_output"
                printf "│\x1b[1;31m██\x1b[0m expected : %s %s --> %s\n" "$drivefunction" "$input" "$expected_output"
                printf "└─────────────────────────────────────────────────────────────────\n" 2>&1
            ;;
        esac
    } always {
        unsetopt shwordsplit
    }
}


for file in $HOME/.zsh/zshenv.d/*.init.zsh(.\N) ; do
    source $file ;
done

