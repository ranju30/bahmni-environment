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

function confirm_password() {
    read -p "Password:" -s PASSWORD
    if([ "$PASSWORD" != "p@ssw0rd" ]) then
        echo -e "$red Incorrect password. Please try again. $original"
        exit 1
    fi
    echo
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
    ps aux | grep pppd | grep -v grep    
    if([ $? -ne 0 ]) then
        sudo pkill -9 -f wvdial
        which wvdial
        if([ $? -eq 0 ]) then
            sudo wvdial &
        else
            echo -e "$red No modem found. Please manually start Network. $original"
        fi
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
    DAY=`date | cut -f1 -d' '`
    LOGS_DIR=/tmp/logs_$DAY
    rm -rf $LOGS_DIR
    mkdir -p $LOGS_DIR
    get_failed_events_log
    
    cp /var/log/httpd/access_log $LOGS_DIR
    cp /home/bahmni/apache-tomcat-8.0.12/logs/catalina.out $LOGS_DIR
    cp /home/bahmni/apache-tomcat-8.0.12/logs/openmrs.log $LOGS_DIR
    cp /home/bahmni/apache-tomcat-8.0.12/logs/openelis.log $LOGS_DIR
    cp /var/log/openerp/openerp-server.log $LOGS_DIR

    cp /tmp/failed_events_openmrs.csv $LOGS_DIR
    cp /tmp/failed_events_openelis.csv $LOGS_DIR
    cp /tmp/failed_events_openerp.csv $LOGS_DIR

    zip -r $LOGS_DIR.zip $LOGS_DIR
    cp $LOGS_DIR.zip /home/bahmni/Desktop/bahmni_latest_logs.zip
}
