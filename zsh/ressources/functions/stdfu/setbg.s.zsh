#!/usr/bin/zsh

# setbg COMMAND [command args]
# command is launched in background and detached from the current shell without shell monitoring

setbg () {
    setopt nomonitor &&
    nohup $@ &
    setopt monitor
}
