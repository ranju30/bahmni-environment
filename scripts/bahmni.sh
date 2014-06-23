#!/bin/bash
set -e


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
	echo "[WARNING] All services required for Bahmni will be shut down"
	echo "Make sure you run [bahmni start] before you use Bahmni"
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

status() {
	services=("httpd" "openerp-server" "tomcat" "mysql" "pgsql-9.2")
	# up_count=0
	# down_count=0
	for service in "${services[@]}" 
	do
   		if(is_service_running $service) then
   			echo "$service...... Running"
   			# up_count++
		else
			echo "$service...... Not running"
			# down_count++
		fi
	done
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