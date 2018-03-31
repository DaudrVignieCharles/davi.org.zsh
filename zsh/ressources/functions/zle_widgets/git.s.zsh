#!/usr/bin/zsh

__is_git(){
    if $(git rev-parse --is-inside-work-tree 2>/dev/null) ; then
        return 0
    else
        return 1
    fi
}

__zz_zle_git_status () {
    if __is_git ; then
        BUFFER="git status"
    else
        export zle_highlight[(r)default:*]="default:fg=red,bold"
        POSTDISPLAY=$'\nNot a git directory.'
        BUFFER=""
    fi
    zle accept-line
}
zle -N __zz_zle_git_status
bindkey "^[:^[:" __zz_zle_git_status

__zz_zle_git_add () {
    if __is_git ; then
        BUFFER="git add $BUFFER"
    else
        export zle_highlight[(r)default:*]="default:fg=red,bold"
        POSTDISPLAY=$'\nNot a git directory.'
        BUFFER=""
    fi
    zle accept-line
}
zle -N __zz_zle_git_add
bindkey "^[:^[;" __zz_zle_git_add

__zz_zle_git_commit () {
    if __is_git ; then
        BUFFER="git commit"
    else
        export zle_highlight[(r)default:*]="default:fg=red,bold"
        POSTDISPLAY=$'\nNot a git directory.'
        BUFFER=""
    fi
    zle accept-line
}
zle -N __zz_zle_git_commit
bindkey "^[:^[!" __zz_zle_git_commit

__zz_zle_git_push_master () {
    if __is_git ; then
        local repo=${$(git rev-parse --show-toplevel):t}
        BUFFER="git push $repo master"
    else
        export zle_highlight[(r)default:*]="default:fg=red,bold"
        POSTDISPLAY=$'\nNot a git directory.'
        BUFFER=""
    fi
    zle accept-line
}
zle -N __zz_zle_git_push_master
bindkey "^[:^[m" __zz_zle_git_push_master

__zz_zle_git_push_current () {
    if __is_git ; then
        local repo=${$(git rev-parse --show-toplevel):t}
        local current=$(git branch | sed -n 's/\* //p')
        BUFFER="git push $repo $current"
    else
        export zle_highlight[(r)default:*]="default:fg=red,bold"
        POSTDISPLAY=$'\nNot a git directory.'
        BUFFER=""
    fi
    zle accept-line
}
zle -N __zz_zle_git_push_current
bindkey "^[:^[*" __zz_zle_git_push_current

__zz_zle_git_pull_master () {
    if __is_git ; then
        local repo=${$(git rev-parse --show-toplevel):t}
        BUFFER="git pull $repo master"
    else
        export zle_highlight[(r)default:*]="default:fg=red,bold"
        POSTDISPLAY=$'\nNot a git directory.'
        BUFFER=""
    fi
    zle accept-line
}
zle -N __zz_zle_git_pull_master
bindkey "^[:^[l" __zz_zle_git_pull_master

__zz_zle_git_tree () {
    if __is_git ; then
        BUFFER="gitree"
    else
        export zle_highlight[(r)default:*]="default:fg=red,bold"
        POSTDISPLAY=$'\nNot a git directory.'
        BUFFER=""
    fi
    zle accept-line
}
zle -N __zz_zle_git_tree
bindkey "^[:^[t" __zz_zle_git_tree

