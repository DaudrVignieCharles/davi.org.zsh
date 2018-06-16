#!/usr/bin/zsh

zz.main.help(){
    local help_path="$HOME/.zsh/ressources/sources/help"
    main_menu="1 ⮩ main builtin commands
2 ⮩ ZLE widgets
3 ⮩ dev builtin functions
4 ⮩ unittest module
5 ⮩ code specification

Q ⮩ Exit

>>> "
    while true ; do
        clear
        printf "%s" "$main_menu"
        read -k1 user_choice
        case $user_choice in
            ("1")
                $PAGER $help_path/builtin_commands.help
            ;;
            ("2")
                $PAGER $help_path/zle-widgets.help
            ;;
            ("3")
                $PAGER $help_path/dev_functions.help
            ;;
            ("4")
                $PAGER $help_path/unittest.help
            ;;
            ("5")
                $PAGER $help_path/specs.help
            ;;
            ("Q"|"q")
                printf "\n"
                return 0
            ;;
        esac
    done
}
alias help=zz.main.help
