#!/bin/sh

TERM=xterm
export TERM

SESSION=YOUR-SESSION-NAME
ROOT=/path/to/your/app

if screen -ls | grep $SESSION > /dev/null; then
    screen -U -r -d $SESSION
else
    cd $ROOT
    screen -c .screenrc
fi
