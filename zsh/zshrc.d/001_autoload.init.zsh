#!/usr/bin/zsh

(){
    # Builtin functions
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook;
    autoload -z edit-command-line;
    autoload compinit;
    autoload -U zsh-mime-setup;
    autoload -U zsh-mime-handler;
    autoload -U zed
    # ZZ functions
    autoload zc.inputbox
}
