#!/bin/bash
set -e
yellow='\e[33m'
original='\e[0m'
red='\e[91m'
green='\e[92m'


function is_service_running() {
    if (( $(ps -ef | grep -v grep | grep $1 | wc -l) > 0 ))
    then
        return 0
    else
        return 1
    fi
}

function start_service() {
    echo -e "Starting up $green $1 $original service..."
    if(!(is_service_running $1)) then
        sudo service $1 start
    else
        echo -e "Service $1 is already up"
    fi
}

function start_service_openerp() {
    echo -e "Starting up $green Openerp $original service..."
    if(!(is_service_running openerp-server)) then
        echo "Starting Openerp ...."
        sudo service openerp start
    else
        echo -e "Service Opnerp is already up"
    fi
}

function start_internet() {
    echo -e "Connecting to $green Internet $original ..."
    ping -q -c2 google.com > /dev/null
    if([ $? -ne 0 ]) then
    	sudo pkill -9 -f wvdial
        sudo wvdial &
    else
        echo -e "Already connected to Internet"
    fi
}


function start_pgsql() {
    echo -e "Starting up $green postgresql-9.2 $original ..."
    if(!(is_service_running pgsql-9.2 )) then
        sudo service postgresql-9.2 start 
    else
        echo -e "Service postgresql-9.2 is already up"
    fi
}


function stop_service() {
    echo -e "Checking $yellow $1 $original service..."
    if(is_service_running $1) then
        sudo service $1 stop
        echo -e "Stopped $red $1 $original"
    fi
}

function get_logs() {
    TIME=`date +%Y%m%d_%H%M%S`
    LOGS_DIR=/tmp/logs$TIME
    mkdir -p $LOGS_DIR
    
    cp /var/log/httpd/access_log $LOGS_DIR
    cp /home/bahmni/apache-tomcat-8.0.12/logs/catalina.out $LOGS_DIR
    cp /home/bahmni/apache-tomcat-8.0.12/logs/openmrs.log $LOGS_DIR
    cp /home/bahmni/apache-tomcat-8.0.12/logs/openelis.log $LOGS_DIR
    cp /var/log/openerp/openerp-server.log $LOGS_DIR

    zip -r $LOGS_DIR.zip $LOGS_DIR
}
