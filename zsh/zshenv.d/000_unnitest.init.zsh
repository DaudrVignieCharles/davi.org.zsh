#!/usr/bin/zsh


unnitest(){
    typeset -a validTests
    validTests=( '==' '!=' '=~' '<' '>' '-eq' '-ne' '-lt' '-gt' '-le' '-ge' )
    success(){
        echo "ASSERTION SUCCESS"
    }
    failure(){
        echo "ASSERTION FAILURE"
    }
    fatal(){
    }
    zmodload -e zsh/regex || zmodload zsh/regex
    typeset line
    typeset -a allTests
    while read -r line ; do
        allTests+=( "$line" )
    done
    unset match
    if ! [[ "$1" == "true" ]] ; then
        return 0
    fi
    if [[ "$2" != "{" ]] ; then
        printf "ZTestError : Cant find testing block opening bracket.\n"
        return 2
    else
        shift
    fi
    unsetopt shwordsplit
    typeset oneTest
    typeset testFunction
    for oneTest in $allTests ; do
        typeset -a arrayTest
        read -A arrayTest<<<$oneTest
        if [[ $( whence -w ${arrayTest[1]} ) != "${arrayTest[1]}: function" ]] ; then
            printf "Error : %s is not a ZSH function.\n" "${arrayTest[1]}"
	    return 3
        else
            testFunction="${arrayTest[1]}"
	    shift arrayTest
        fi
        if [[ "${arrayTest[1]}" != "{" ]] ; then
            printf "ZTestError : Cant find opening bracket\n"
        else
            shift arrayTest
        fi
        typeset term
        typeset -a testFunctionArgs
        for term in $arrayTest ; do
            if [[ "$term" == "}" ]] ; then
                shift arrayTest
                break
            else
                testFunctionArgs+=( "$term" )
                shift arrayTest
            fi
        done
        typeset ret
        ret=false
        case ${arrayTest[1]} in
            'ret'|'return') ret=true
            ;;
            'out'|'output') alias -g §fd=''
            ;;
            'err'|'error')  alias -g §fd='2>&1 1>/dev/null'
            ;;
            *) printf "ZTestError : %s is not a valid FD\n" "${arrayTest[1]}"; return 3
            ;;
        esac
        shift arrayTest
        typeset testTest
        typeset testExpectedData
        typeset testExpectedReturn
        typeset testRealData
        if $ret ; then
            testExpectedReturn="${arrayTest[1]}"
            $testFunction $testFunctionArgs 1>/dev/null 2>&1
            testRealReturn="$?"
            if [[ "$testRealReturn" -eq "$testExpectedReturn" ]] ; then
                echo "test réussi"
            else
                echo "test échoué"
            fi
        else
            testTest="${arrayTest[1]}"
            if [[ "${validTests[(r)$testTest]}" != "$testTest" ]] ; then
                printf "ZTestError : %s is not recognized as a valid test.\n" "$testTest"
                return 2
            fi
            shift arrayTest
            testExpectedData="${arrayTest[*]}"
            testExpectedData="${testExpectedData:Q}"
            testRealData=$( $testFunction $testFunctionArgs §fd)
            if eval "[[ \"$testRealData\" $testTest \"$testExpectedData\" ]]" ; then
                printf "SUCCESS for %s\n" "$testTest"
            else
                printf "FAILURE for %s\n" "$testTest"
            fi
        fi
        unset oneTest
        unset testFunction
        unset term
        unset ret
        unset arrayTest
        unset testFunctionArgs
        unset testTest
        unalias §testG
        unset testExpectedData
        unset testExpectedReturn
        unset testRealData
     done
}
alias ztest='unnitest<<"}"'
