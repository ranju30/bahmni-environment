#!/bin/bash
set -e
yellow='\e[33m'
white='\e[0m'
red='\e[91m'
green='\e[92m'

PATH_OF_CURRENT_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $EUID -ne 0 ]]; then
   echo "[Error] This script must be run as root or with sudo!" 1>&2
   exit 1
fi


function is_service_running() {
    if (( $(ps -ef | grep -v grep | grep $1 | wc -l) > 0 ))
    then
        return 0
    else
        return 1
    fi
}

function start_service() {
    echo "Starting up $1 service..."
    if(!(is_service_running $1)) then
        sudo service $1 start
    else
        echo -e "Service $1 is already up"
    fi
}

function start_pgsql() {
	echo "Starting up postgresql-9.2..."
	if(!(is_service_running pgsql-9.2 )) then
		sudo service postgresql-9.2 start 
	else
		echo -e "Service postgresql-9.2 is already up"
	fi
}


function stop_service() {
    echo "Shutting down $1 service..."
    if(is_service_running $1) then
        sudo service $1 stop
    fi

}

# stops all services
stop() {
    echo "=================================================================="
    echo -e "$yellow[WARNING] All services required for Bahmni will be shut down$white"
    echo -e "$yellow Make sure you run [bahmni start] before you use Bahmni$white"
    echo "=================================================================="

	stop_service openerp
	
	echo "Shutting down tomcat service..."
	if(is_service_running tomcat) then
		ps aux | grep [t]omcat | awk '{print $2}' | xargs -I PID sudo kill -9 PID
	fi

    sleep 3
	stop_service mysql
	stop_service postgresql-9.2
	stop_service httpd
}

status() {
    bahmni_services=("httpd" "openerp-server" "tomcat" "mysql" "pgsql-9.2")
    up_count=0
    down_count=0
    for service in "${bahmni_services[@]}"
    do
        if(is_service_running $bahmni_services) then
            echo "$service...... Running"
            let up_count=$up_count+1
        else
            echo "$service...... Not running"
            let down_count=$down_count+1
        fi
    done
    services_count=${#bahmni_services[@]}
    if (("$services_count" != "$up_count")); then
        echo "=================================================================="
        echo -e "$red[ERROR] $down_count out of $services_count services are not running$white"
        echo -e "$red[ERROR] Please run [bahmni start] to bring up all services.$white"
        echo "=================================================================="
    else
        echo "=================================================================="
        echo -e "$green Bahmni is ready to be used$white"
        echo "=================================================================="
    fi
}

# starts all services
start() {
	echo "=================================================================="
	echo "All services required for Bahmni will be starting up"
	echo "Run [bahmni status] to check the status"
	echo "=================================================================="
	start_service mysql
	start_pgsql
	start_service httpd
	sleep 3
	start_service openerp
	start_service tomcat
	echo "=================================================================="
	echo "Bahmni services started... "
	echo "Tomcat will take upto 5 mins to fully come up...."
	echo "=================================================================="
}

# restarts all services
restart() {
	echo "=================================================================="
	echo "Restarting all services required for Bahmni"
	echo "Run [bahmni status] to check the status"
	echo "=================================================================="
	stop
	sleep 3
	start
}

backup() {
	sudo $PATH_OF_CURRENT_SCRIPT/backup-all-dbs.sh -b /backup
}

tailFunction() {
	case "$1" in
		"access" )
			sudo tail -f /var/log/httpd/access_log
			;;
		"tomcat" )
			sudo tail -f /home/bahmni/apache-tomcat-7.0.22/logs/catalina.out
			;;
		"openerp" )
			sudo tail -f /var/log/openerp/openerp-server.log
			;;
		* )
			echo "Incorrect parameter for tail"
			printUsage
			exit 1
			;;
	esac
}

printUsage() {
	echo -e "-----------------------------------------"
	echo -e "Command line tool for managing bahmni"
	echo -e "\nUsage:"
	echo -e "\tbahmni start"
	echo -e "\tbahmni stop"
	echo -e "\tbahmni restart"
	echo -e "\tbahmni logs [ tomcat | access | openerp ]"
	echo -e "\tbahmni backup-all-dbs"
	echo -e "\tbahmni status"
	echo -e "\n-----------------------------------------"
}

case "$1" in
	"help" )
		printUsage
		;;
	"start" )
		start
		;;
	"stop" )
		stop
		;;
	"restart" )
		restart
		;;
	"backup-all-dbs" )
	    backup
		;;
	"logs" )
	    tailFunction $2
		;;
	"status" )
		status
		;;
	* )
		echo "[ERROR] Invalid option $1"
		printUsage
		;;
esac