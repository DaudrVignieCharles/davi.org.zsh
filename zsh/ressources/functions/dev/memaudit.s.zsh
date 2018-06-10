#!/usr/bin/zsh
memaudit(){
    get_total(){
        local AUDITPID=$1
        local UNIT=$2
        local DIVID=$3
        printf "%5s %s\n" "$( pmap -x $AUDITPID |tail -1|awk -v DIVID=$DIVID '{out=int( $3 / DIVID)i ; print out}' )" "$UNIT"
    }

    typeset -a ARGS=( $@ )
    typeset ARG
    typeset UNIT # Unité de mesure : Kb, Mb, Gb.
    typeset -i DIVID=1 # Permet de diviser les Kb pour obtenir des Mb ou Gb.
    typeset AUDITPID # Pid of the process.
    typeset -i PID_MAX=$(cat /proc/sys/kernel/pid_max)
    typeset MONITOR=false
    typeset -i MON=1 # Intervalle de mise à jour.
    typeset HELP=false
    typeset HELP_TEXT="Utilisation : memaudit [OPTION] PID
-m      --mega          La mémoire occupée sera indiquée en mega octet.
-g      --giga          La mémoire occupée sera indiquée en giga octet.
-i[=n]   --monitor[=n]  Renvoi le résultat toute les n secondes si il à changé."
    typeset OUTPUT
    typeset ERR_UNIT="memaudit : erreur : Une seule unité peut être spécifiée à la fois."
    typeset ERR_PID1="memaudit : erreur : Vous ne pouvez indiquer qu'un PID."
    typeset ERR_PID2="memaudit : erreur : Invalid PID, PID must be between 0 and 32768."

    ! [[ -n $ARGS ]] && printf "%s\n" "$HELP_TEXT" && return 0
    {
        for ARG in $ARGS ; do
            case $ARG in
                ('-m'|'--mega') ! [[ -n $UNIT ]] && { UNIT='Mb' ; DIVID=1024 } || { printf "%s\n" "$ERR_UNIT" ; return 1 }
                ;;
                ('-g'|'--giga') ! [[ -n $UNIT ]] && { UNIT='Gb' DIVID=1048576 } || { printf "%s\n" "$ERR_UNIT" ; return 1 }
                ;;
                (<->) if [[ -n $AUDITPID ]] ; then
                        printf "%s\n" "$ERR_PID1";
                        return 1;
                    else
                        AUDITPID=$ARG
                        if [[ $AUDITPID -gt $PID_MAX ]] ; then
                            printf "%s\n" "$ERR_PID2";
                            return 1;
                        fi
                    fi
                ;;
                ('-i'|'--monitor') MONITOR=true
                ;;
                (-i=<->|--monitor=<->) MONITOR=true
                    if [[ "$ARG" == -i=<-> ]] then
                        MON=$(printf "%s\n" "${(ARG:s/-i=/}")
                    elif [[ "$ARG" == --monitor=<-> ]] ; then
                        MON=$(printf "%s\n" "${ARG:s/--monitor=/}")
                    else
                        printf "memaudit : erreur inconnue dans :
	local name=${0:t}
    -> for
        -> case (monitor)
    debug :
    ARG=%s
    MON=%sqq\n" "$ARG" "$MON"
                    fi
                ;;
                ('-h'|'--help') HELP=true
                ;;
                (*) printf "memaudit : erreur : $ARG : Option inconnue.\n" && printf "\n%s\n" "$HELP_TEXT" && return 1
                ;;
            esac
        done
        ! [[ -n $UNIT ]] && UNIT='Kb' && DIVID=1
        $HELP && printf "%s\n" "$HELP_TEXT" && return 0
        ! [[ -d /proc/$PID ]] && printf "memaudit : erreur : le PID %s n'existe pas.\n" "$AUDITPID" && return 1
        OUTPUT=$(get_total $AUDITPID $UNIT $DIVID) && date +"%d/%m/%Y %T : $OUTPUT"
        if $TOTAL && $MONITOR ; then
            while true ; do
                ! [[ -d /proc/$AUDITPID ]] && printf "memaudit : erreur : Il semble que le processus soit terminé.\n" && return 2
                sleep $MON ;
                NOUTPUT=$(get_total $AUDITPID $UNIT $DIVID)
                [[ $NOUTPUT != $OUTPUT ]] && date +"%d/%m/%Y %T : $OUTPUT"
                OUTPUT=$NOUTPUT
            done
        fi
        return 0
    } always {
        unset AUDITPID
    }
}
