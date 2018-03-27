#!/usr/bin/zsh

() {
    local msg="\
                                ███████╗███████╗
                                ╚══███╔╝╚══███╔╝
                                  ███╔╝   ███╔╝ 
                                 ███╔╝   ███╔╝  
                                ███████╗███████╗
                                ╚══════╝╚══════╝

                                  davi.org.zsh
\n"
    DEBINFO="$(cat /etc/os-release|grep VERSION=|sed s/VERSION=//g)"
    if type linuxlogo >& - ; then
        msg+="$(linuxlogo -k -g -F "Debian $DEBINFO GNU/Linux, Kernel Version : #V\n#P : #N CPU #X #T, RAM : #R\n#U\n" | sed '$d')\n\n"
    else
        msg+="System : Debian $DEBINFO GNU/Linux\nKernel : $(uname -v)\nUptime : Up since $(uptime -s), $(uptime -p)\n\n"
    fi
    msg+="$(date "+Bonjour $USER et bienvenue sur $HOST, nous sommes le %A %d %B %Y et il est %Hh%M")\n"
    if type lolcat >& - && [[ $1 != "quiet" ]] ; then
        printf "%b\n" "$msg" |/usr/games/lolcat -a -d 1
    else
        printf "%b\n" "$msg"
    fi
} "$@"
