#!/usr/bin/zsh

(){
    zle -N edit-command-line
    bindkey "^X^E" edit-command-line
    bindkey "^[[1;5D" backward-word
    bindkey "^[[1;5C" forward-word
    # WARNING : Ctrl-Backward don't work?
    # It need a workaround : If you use Konsole (KDE), go to "Edit current profile",
    # go to "Keyboard" tab then "edit".
    # click the "Add" button and under the Key Combination column type Backspace+Ctrl. In the  Output column type 0x08.
    bindkey "\C-H" backward-kill-word
    bindkey "\e[3;5~" kill-word
    zsh-mime-setup
}
