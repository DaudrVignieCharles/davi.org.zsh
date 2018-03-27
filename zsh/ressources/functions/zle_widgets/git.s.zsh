#!/usr/bin/zsh

__zz_zle_git_status () {
    BUFFER="git status"
    zle accept-line
}
zle -N __zz_zle_git_status
bindkey "^[:^[:" __zz_zle_git_status

__zz_zle_git_add () {
    BUFFER="git add $BUFFER"
    zle accept-line
}
zle -N __zz_zle_git_add
bindkey "^[:^[;" __zz_zle_git_add

__zz_zle_git_commit () {
    BUFFER="git commit"
    zle accept-line
}
zle -N __zz_zle_git_commit
bindkey "^[:^[!" __zz_zle_git_commit

__zz_zle_git_push_master () {
    local repo=${$(git rev-parse --show-toplevel):t}
    BUFFER="git push $repo master"
    zle accept-line
}
zle -N __zz_zle_git_push_master
bindkey "^[:^[m" __zz_zle_git_push_master

__zz_zle_git_push_current () {
    local repo=${$(git rev-parse --show-toplevel):t}
    local current=$(git branch | sed -n 's/\* //p')
    BUFFER="git push $repo $current"
    zle accept-line
}
zle -N __zz_zle_git_push_current
bindkey "^[:^[*" __zz_zle_git_push_current

__zz_zle_git_pull_master () {
    local repo=${$(git rev-parse --show-toplevel):t}
    BUFFER="git pull $repo master"
    zle accept-line
}
zle -N __zz_zle_git_pull_master
bindkey "^[:^[l" __zz_zle_git_pull_master

__zz_zle_git_tree () {
    BUFFER="gitree"
    zle accept-line
}
zle -N __zz_zle_git_tree
bindkey "^[:^[p" __zz_zle_git_tree

