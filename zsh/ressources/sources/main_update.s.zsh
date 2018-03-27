#!/usr/bin/zsh

zz.main.update () {
    check_for_update () {
        typeset -a tmp
        tmp=( $(git ls-remote .) )
        typeset -A COMMITS_HASH
        local i
        for (( i=$#tmp-1 ; i>=0 ; i-=2 )) ; do
            COMMITS_HASH[$tmp[$i+1]]="$tmp[$i]"
        done
        local ERR=false
        if [[ -z $COMMITS_HASH[refs/heads/master] ]] ; then
            printf "refs/heads/master not found, aborting.\n"
            ERR=true
        fi
        if [[ -z $COMMITS_HASH[refs/remotes/davi.org.zsh/master] ]] ; then
            printf "refs/remotes/davi.org.zsh/master not found, aborting.\n"
            ERR=true
        fi
        {$ERR} && return 1
        if [[ $COMMITS_HASH[refs/heads/master] == $COMMITS_HASH[refs/remotes/davi.org.zsh/master] ]] ; then
            printf "The local repository is the same as the remote repository.\n"
            printf "No update available.\n"
            return 1
        else
            printf "Your local repository is different from the remote repository.\n"
            printf "Attempt to update from remote repository :\n"
            return 0
        fi
    }

    zparseopts ns=NOSYNC -no-sync=NOSYNC d=DRYRUN -dry-run=DRYRUN

    OLD_PWD="$PWD"
    cd "$ZDEV_PATH"
    if check_for_update ; then
        if [[ -n "$DRYRUN" ]] ; then
            git pull --dry-run --stat davi.org.zsh master
            cd "$OLD_PWD"
            return 0
        else
            git pull --stat davi.org.zsh master
            if [[ -n "$NOSYNC" ]] ; then
                cd "$OLD_PWD"
                return 0
            else
                zz.main.propage
                cd "$OLD_PWD"
                return 0
            fi
        fi
    fi
    cd "$OLD_PWD"
}
