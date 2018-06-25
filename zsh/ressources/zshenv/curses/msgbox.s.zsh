#!/usr/bin/zsh

zc.textbox(){
    setopt ksharrays
    local line # generic var for "while read line"
    local strhelp help title text
    local wcolors tcolors
    strhelp="zc.textbox TEXT [OPTION]
-h, --help           : display help and exit
-m, --max            : box size will always be the maximum.
-t, --title TITLE    : display title
-wc, --window-colors COLORS : 
-tc, --text-colors COLORS   : 

For -wc and -tc, COLORS consists of two color pairs in the form \"fgcolor/bgcolor\".

zc.textbox can read from stdin, you can use pipe or heredoc,
if it is, TEXT should not be passed as argument else it will
be ignored.i"
    # parse and remove opts
    zparseopts -E -D h=help -help=help m=max -max=max \
        t:=title -title:=title \
        wc:=wcolors -window-colors:=wcolors \
        tc:=tcolors -text-colors:=tcolors
    if [[ -n $help ]] ; then
        printf "%s\n" "$strhelp"
        return 0
    fi
    if [[ -n ${title[1]} ]] ; then
        # strip newlines and format title
        title="┤ ${title[1]//$NEWLINE/ } ├"
        # if -t= or --title=, remove '=' from arg
        [[ "${title[2]}" == "=" ]] && title[2]=''
    fi
    if [[ -z ${wcolors} ]] ; then
        wcolors='white/black'
    else
        [[ "${title[0]}" == "=" ]] && title[0]=''
        wcolors=${wcolors[1]}
    fi
    if [[ -z ${tcolors} ]] ; then
        tcolors='white/black'
    else
        [[ "${title[0]}" == "=" ]] && title[0]=''
        tcolors=${tcolors[1]}
    fi
    # get text from args or stdin
    if ! [[ -t 0 ]] ; then
        text="$(</dev/stdin)"
    elif [[ $# -ne 1 ]] ; then
        printf "error while parsing arguments :\n%s\n" "$strhelp"
        return 1
    else
        text="$1"
    fi
    local longest_line=0
    local nbr_lines=0
    typeset -a f_text
    local max_win_lin=$((LINES-2))
    local max_win_col=$((COLUMNS-2))
    local win_lin=0
    local win_col=0
    IFS='' # IFS must be none, else read strip blank at begining of line
    printf "%s\n" "$text" | while read line ; do
        # allows to resize window automatically according
        # to the length of the largest line.
        if [[ "${#line}" -gt "$longest_line" ]] ; then
            longest_line=${#line}
        fi
        # allows to split line into several if it does
        # more than the size of the screen.
        if [[ ${#line} -gt $max_win_col ]] ; then
            local i j
            local steps=$(( ${#line} / $max_win_col ))
            local mod=$(( ${#line} % $max_win_col - 1 ))
            for ((j=0 ; i<=$steps ; i+=$max_win_col)) ; do
                f_text+=( "$line[$i, $((i+max_win_col))]" )
                ((nbr_lines++))
            done
            if [[ $mod -ne 0 ]] ; then
                f_text+=( "${line[0, -$]}" )
            fi
        else
            f_text+=($line)
            ((nbr_lines++)) # TODO: COPY ^
        fi
    done
    unset IFS
    if [[ -n $max ]] ; then
        win_lin=$max_win_lin
        win_col=$max_win_col
    else
        if [[ $nbr_lines -ge $max_win_lin ]] ; then
            win_lin=$max_win_lin
        else
            win_lin=$nbr_lines
        fi
        if [[ $longest_line -ge $max_win_col ]] ; then
            win_col=$max_win_col
        else
            if [[ ${#title} -gt $longest_line ]] ; then
                win_col=${#title}
            else
                win_col=$longest_line
            fi
        fi
    fi
    {
        tput civis
        zmodload -e zsh/curses || zmodload zsh/curses
        zmodload -e zsh/mathfunc || zmodload zsh/mathfunc
        zcurses init
        zcurses addwin main $((win_lin+2)) $((win_col+2)) 0 0
        zcurses attr main white/black
        zcurses border main
        if [[ -n "$title" ]] ; then
            zcurses move main 0 $(( (win_col+2)/2-$#title/2 ))
            zcurses string main "$title"
        fi
        zcurses refresh main
        zcurses addwin text $win_lin $((win_col+1)) 1 0 main
# BEGIN TODO
# remove these line, build text array and split long line in upper while loop
        setopt shwordsplit
        IFS="${NEWLINE}" # split text with newline
        text=($text)
        unset IFS
        unsetopt shwordsplit
        local i
# END TODO
        for (( i=0 ; i<${win_lin} ; i++ )) ; do
            zcurses move text $i 1
            zcurses string text "${text[$i]}"
        done
        zcurses refresh text
        sleep 3
    } always {
        zcurses clear text
        zcurses refresh text
        zcurses delwin text
        zcurses clear main
        zcurses refresh main
        zcurses delwin main
        zcurses end
        unsetopt ksharrays
        tput cnorm
    }
}
