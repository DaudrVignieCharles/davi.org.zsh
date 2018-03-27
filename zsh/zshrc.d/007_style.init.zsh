#!/usr/bin/zsh

(){
    zstyle ':completion:*' completer _expand _complete _correct _approximate
    zstyle ':completion:*' fornews@rutube-team.rumat 'Completing %d'
    zstyle ':completion:*' group-name ''
#   zstyle ':completion:*' menu select=2
    zstyle ':completion:*' menu select
    eval "$(dircolors -b)"
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
    zstyle ':completion:*' list-colors ''
    zstyle ':completion:*' list-prompt %SAt %p: "Hit TAB for more, or the character to insert"%s
    zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
#   zstyle ':completion:*' menu select=long
    zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
    zstyle ':completion:*' use-compctl false
    zstyle ':completion:*' verbose true
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
    zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
    zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
    zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
    zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                             /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
    zstyle ':completion:*' use-cache on
    zstyle ':completion:*' cache-path ~/.zsh_cache
    zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"
}
