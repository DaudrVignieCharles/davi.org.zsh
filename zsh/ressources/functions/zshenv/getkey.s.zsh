#!/usr/bin/zsh

 # This script is an interface for the ZSH builtin `read`,
 # it allows to capture a single keyboard key including special keys like RETURN,
 # BACKSPACE, ESC, Fx, BLANK, TAB, arrow keys(UP, DOWN, LEFT, RIGHT) etc.
 # If it is a raw key, it returns it, otherwise,
 # it returns an ASCII representation of the special key.
 # This is particularly useful for a text user interface, controlled with the keyboard using special keys.

getkey(){
    local key tmp
    read -rks key
    case $key in
        $'\x1b') read -rsk -t 0.005 tmp || { printf "ESC\n" && return 0 }
            case $tmp in 
                $'\x5b') read -rsk1 tmp &&
                    case $tmp in
                        'A') printf "UP\n"
                        ;;
                        'B') printf "DOWN\n"
                        ;;
                        'C') printf "RIGHT\n"
                        ;;
                        'D') printf "LEFT\n"
                        ;;
                        'H') printf "HOME\n"
                        ;;
                        'F') printf "END\n"
                        ;;
                        '3') printf "DEL\n" && read -rks tmp
                        ;;
                        '5') printf "PAGEUP\n" && read -rks tmp
                        ;;
                        '6') printf "PAGEDOWN\n" && read -rks tmp
                        ;;
                        '2') read -rks tmp &&
                            case $tmp in
                                '0') printf "F9\n" && read -rks tmp
                                ;;
                                '1') printf "F10\n" && read -rks tmp
                                ;;
                                '3') printf "F11\n" && read -rks tmp
                                ;;
                                '4') printf "F12\n" && read -rks tmp
                                ;;
                                '~') printf "INSERT\n"
                            esac
                        ;;
                        '1') read -rsk tmp &&
                            case $tmp in
                                '5') printf "F5\n" && read -rks tmp
                                ;;
                                '7') printf "F6\n" && read -rks tmp
                                ;;
                                '8') printf "F7\n" && read -rks tmp
                                ;;
                                '9') printf "F8\n" && read -rks tmp
                                ;;
                            esac
                        ;;
                    esac
                ;;
                'O') read -rks tmp
                    case $tmp in
                        'P') printf "F1\n"
                        ;;
                        'Q') printf "F2\n"
                        ;;
                        'R') printf "F3\n"
                        ;;
                        'S') printf "F4\n"
                        ;;
                    esac
                ;;
            esac
        ;;
        $'\x7f') printf "BACKSPACE\n"
        ;;
        # assume this is a "normal key"
        $'\t') printf "TAB\n"
        ;;
        $'\n') printf "NEWLINE\n"
        ;;
        $' ')  printf "BLANK\n"
        ;;
        *) printf "%s\n" "$key"
        ;;
    esac
}
