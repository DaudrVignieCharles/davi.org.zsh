#!/usr/bin/zsh

export ZTEST="$HOME/.zsh_test.log"

ztest(){
    {
        setopt shwordsplit
        # myfunction(){
        #   echo "$@"
        # }
        # ztest myfunction stderr -eq "hello world" "hello world"
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

        if [[ "$fdreturn" == "ret" ]] ; then
            input=($1)
            expected_output="$2"
            $drivefunction $input
            real_output=$?
            if [[ $real_output -ne $expected_output ]] ; then
                printf "\x1b[1;31mztest\x1b[0m : return code of function \"%s\" :\n" "$drivefunction"  2>&1
                printf "\x1b[1;31mfailure\x1b[0m : %s -eq %s\n" "$expected_output" "$real_output" 2>&1
            else
                printf "\x1b[1;32mztest\x1b[0m : return code of function \"%s\" :\n" "$drivefunction" 2>&1
                printf "\x1b[1;32msuccess\x1b[0m: %s -eq %s\n" "$expected_output" "$real_output" 2>&1
            fi
            return 0
        fi
        drivetest="$1"
        input=($2)
        expected_output="$3"
        if [[ "$fdreturn" == "out" ]] ; then
            real_output=$($drivefunction $input)
        elif [[ "$fdreturn" == "err" ]] ; then
            real_output=$($drivefunction $input 2>&1 1>/dev/null)
        else
            printf "\x1b[1;31mztest\x1b[0m : error while testing function \"%s\" :\n" "$drivefunction" 2>&1
            printf "Invalid arguments \"%s\" : must be one of out|err|ret." 2>&1
            return 1
        fi
        err=$(eval "[[ $expected_output $drivetest $real_output ]]" 2>&1 )
        eval "[[ $expected_output $drivetest $real_output ]]"
        ret=$?
        if [[ -n $err ]] ; then
            printf "\x1b[1;31mztest\x1b[0m : error while testing function \"%s\" :\n" "$drivefunction" 2>&1
            printf "Invalid test \"%s\"." "$drivetest" 2>&1 1>$logfile
            return 1
        fi
        case $ret in
            '0')
                printf "\x1b[1;32mztest\x1b[0m : std$fdreturn of function \"%s\" :\n" "$drivefunction" 2>&1
                printf "\x1b[1;32msuccess\x1b[0m : %s -eq %s\n" "$expected_output" "$real_output" 2>&1
            ;;
            '1')
                printf "\x1b[1;31mztest\x1b[0m : std$fdreturn of function \"%s\" :\n" "$drivefunction" 2>&1
                printf "\x1b[1;31mfailure\x1b[0m : %s -eq %s\n" "$expected_output" "$real_output" 2>&1
            ;;
        esac
    } always {
        unsetopt shwordsplit
    }
}


for file in $HOME/.zsh/ressources/functions/zshenv/*.s.zsh ; do
    source $file ;
done

export ZDEV_PATH=/home/touck/sync.save/programation/projets/davi.org.zsh
