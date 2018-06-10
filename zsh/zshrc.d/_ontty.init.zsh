#!/usr/bin/zsh

# TTY checker used on server "uranus"
# It must be the first of the init files for efficiency reasons

(){
    actions_tty2(){
        SESSION='monitor'
        tmux -2 new-session -d -s $SESSION "sudo logspynow"
        tmux rename-window -t $SESSION:1 "common logs"
        tmux new-window -t $SESSION -a -n fail2ban "sudo fail2ban-log"
        tmux new-window -t $SESSION -a -n nodns "tail -n 300 -f /home/touck/.davi.net.nodns/log"
        tmux new-window -t $SESSION -a -n "SYS/NET" "htop"
        tmux split-window -h "sudo iftop"
        tmux new-window -t $SESSION -a -n "iptraf" "sudo iptraf-ng"
        tmux select-window -t 1
        tmux attach -t $SESSION
    }
    actions_tty3(){
        :
    }
    case $TTY in
        ('2')
        ;;
        ('3') :
        ;;
    esac
}
