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
        local g_local="refs/heads/master"
        local g_remote="refs/remotes/origin/master"
        if [[ -z $COMMITS_HASH[$g_local] ]] ; then
            printf "%s not found, aborting.\n" "$g_local"
            ERR=true
        fi
        if [[ -z $COMMITS_HASH[$g_remote] ]] ; then
            printf "%s not found, aborting.\n" "$g_remote"
            ERR=true
        fi
        {$ERR} && return 1
        if [[ $COMMITS_HASH[$g_local] == $COMMITS_HASH[$g_remote] ]] ; then
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
            git pull --dry-run --stat origin master
            cd "$OLD_PWD"
            return 0
        else
            git pull --stat origin master
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
