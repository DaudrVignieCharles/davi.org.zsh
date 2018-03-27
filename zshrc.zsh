#!/usr/bin/zsh
################################################################################
#                                                                              #
#                                ███████╗███████╗                              #
#                                ╚══███╔╝╚══███╔╝                              #
#                                  ███╔╝   ███╔╝                               #
#                                 ███╔╝   ███╔╝                                #
#                                ███████╗███████╗                              #
#                                ╚══════╝╚══════╝                              #
#                                                                              #
#                                  davi.org.zsh                                #
#                                                                              #
################################################################################
#                                                                              #
# Authors : Daudré-Vignier Charles <daudre.vignier.charles@narod.ru>           #
# More on my github : https://github.com/DaudrVignieCharles/davi.org.zsh       #
#                                                                              #
# Copyright 2016-2018 Charles Daudré-Vignier <daudre.vignier.charles@narod.ru> #
# License : GPLv3                                                              #
#                                                                              #
################################################################################

() {
    # BEGIN CONFIGURATION SECTION
    export LOGIN_MSG=true
    export AUTO_UPDATE=false
    export UPDATE_AUTOSYNC=false
    # END CONFIGURATION SECTION

    # BEGIN LOGIN MESSAGE SECTION
    # For this section see comment in 990_prompt.init.zsh
    if $LOGIN_MSG ; then
        export LOGIN_MSG_PID;
        setopt nomonitor;
        source $HOME/.zsh/login_msg.zsh &;
        LOGIN_MSG_PID=$!;
    fi
    # END LOGIN MESSAGE SECTION

    # BEGIN SOURCE OF RC.D
    typeset file;
    for file in $HOME/.zsh/zshrc.d/[0-9][0-9][0-9]_*.init.zsh ; do
        source $file;
    done
    # END SOURCE OF RC.D
}

