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

function start_service() {
	echo "Starting up $1 service..."
	if(!(is_service_running $1)) then
		sudo service $1 start 
	else
		echo -e "Service $1 is already up"
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
	start_service postgresql-9.2
	start_service httpd
	sleep 3
	start_service openerp
	start_service tomcat
}

# restarts all services
restart() {
	echo "=================================================================="
	echo "Restarting all services required for Bahmni"
	echo "Run [bahmni status] to check the status"
	echo "=================================================================="
	stop
	start
}

status() {
	services=("openerp-server" "tomcat" "mysql" "pgsql-9.2" "httpd")
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
	case $1 in
		"postgres" )
			backup-pgsql $2
			;;
		"mysql" )
			backup-mysql $2
			;;
		"all" )
			backup-all-dbs $2 $3
			;;
		* )
			echo "Invalid backup argument"
			exit 1;
			;;
	esac
}

tailFunction() {
	case "$1" in
		"access" )
			tail -F $TOMCAT_HOME/logs/localhost_access*
			;;
		"catalina" )
			tail -F $TOMCAT_HOME/logs/catalina.out
			;;
		* )
			echo "Incorrect parameter for tail"
			printUsage
			exit 1
			;;
	esac
}

printUsage() {
	echo -e "Command line tool for managing bahmni"
	echo -e "\nUsage:"
	echo -e "\tbahmni start"
	echo -e "\tbahmni stop"
	echo -e "\tbahmni restart"
	echo -e "\tbahmni tail [ tomcataccess | catalinaout ]"
	echo -e "\tbahmni backup [ mysql | postgres | all] [location]"
	echo -e "\tbahmni status"
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
	# "backup" )
	# 	backup $2 $3 $4
	# 	;;
	# "tail" )
	# 	tailFunction $2
	# 	;;
	"status" )
		status $2
		;;
	* )
		echo "[ERROR] Invalid option $1"
		printUsage
		;;
esac