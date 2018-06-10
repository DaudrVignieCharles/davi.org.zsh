#!/usr/bin/zsh

zz.main.help(){
    local help_path="$HOME/.zsh/ressources/sources/help"
    main_menu="1 ⮩ ZZ builtin commands
2 ⮩ ZLE widgets
3 ⮩ ZZ dev functions
4 ⮩ ZZ unittest module

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
            ("Q"|"q")
                kill -INT $sysparams[pid]
            ;;
        esac
    done
}
