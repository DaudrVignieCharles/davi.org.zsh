#!/usr/bin/zsh
(){
    readonly -g infArch=$(uname -m)
    readonly -g infKernelType=$(uname -s)
    readonly -g infOSType=$(uname -o)
    case $infOSType in
        "Android") initFilePath="/system/xbin/init"
        ;;
        "GNU Linux")  initFilePath="/sbin/init"
        ;;
        "BSD")
        ;;
        "Solaris")
        ;;
        "HP-AIX")
        ;;
    esac
    infWordLenght=$(hexdump -s 4 -n 1 -e '"%02x""\n"' $initFilePath)
    case $infWordLenght in
        01) readonly -g infWordLenght=32
        ;;
        02) readonly -g infWordLenght=64
        ;;
    esac
    if [[ -f /proc/sys/kernel/pid_max ]] ; then
        readonly -g infMaxPID=$(cat /proc/sys/kernel/pid_max)
    else
        case $infWordLenght in
            32) readonly -g infMaxPID=32768
            ;;
            64) readonly -g infMaxPID=4194304
            ;;
        esac
    fi
}
