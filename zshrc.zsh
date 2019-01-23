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
# More on my github : https://github.com/Daudre-Vignier-Charles/davi.org.zsh   #
#                                                                              #
# Copyright 2016-2018 Charles Daudré-Vignier <daudre.vignier.charles@narod.ru> #
# License : GPLv3                                                              #
#                                                                              #
################################################################################

() {
    ### BEGIN CONFIGURATION SECTION
    # do the unit test
        export ZUNITTEST
        : ${ZUNITTEST:=false}
    # print the login message
        export LOGIN_MSG
        : ${LOGIN_MSG:=true}
    # automatic update
        export AUTO_UPDATE=false
    # if automatic update, autosync between $HOME/.zshrc and davi.org.zsh git repo
        export UPDATE_AUTOSYNC=false
    # zshrc log file
        export ZLOG="$HOME/.zsh.log"
    # unittest log
        export ZTEST="$HOME/.zsh_test.log"
    # files in these path will be sourced
        export ZSOURCE_PATH=(
            "$HOME/.zsh/ressources/alias"
            "$HOME/.zsh/ressources/functions"
            "$HOME/.zsh/ressources/sources"
            "$HOME/.zsh/ressources/zle-widgets"
        )
    ### END CONFIGURATION SECTION

    ### BEGIN LOGIN MESSAGE SECTION
    # For this section see comment in 990_prompt.init.zsh
    if $LOGIN_MSG ; then
        #export LOGIN_MSG_PID;
        setopt nomonitor;
        source $HOME/.zsh/login_msg.zsh &;
        #LOGIN_MSG_PID=$!;
    fi
    ### END LOGIN MESSAGE SECTION

    ### BEGIN SOURCE OF RC.D
    typeset file;
    if [[ -f $ZLOG ]] ; then
        rm $ZLOG
    fi
    if [[ -f $ZTEST ]] ; then
        rm $ZTEST
    fi
    for file in $HOME/.zsh/zshrc.d/[0-9][0-9][0-9]_*.init.zsh(.) ; do
        printf "source %s\n" "$file" >> $ZLOG
        source $file 1>>$ZLOG 2>&1 ;
    done
    ### END SOURCE OF RC.D
}

