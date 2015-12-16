#!/bin/bash
set -e

function is_service_running() {
    if (( $(ps -ef | grep -v grep | grep $1 | wc -l) > 0 ))
    then
        return 0
    else
        return 1
    fi
}

if(!(is_service_running pppd)) then
    sudo wvdial &
    echo "Started Internet ...."
fi