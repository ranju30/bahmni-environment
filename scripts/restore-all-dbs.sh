#!/bin/bash
set -e

# This script performs restore of mysql and pgsql from dump files

PATH_OF_CURRENT_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"




# checks if service is running
function is_service_running() {
	if (( $(ps -ef | grep -v grep | grep $1 | wc -l) > 0 ))
	then
		return 0
	else
		return 1
	fi
}


############################### CHECK INPUTS ############################################################

echo ""
echo "Running restore DB script at $(date)"
echo "=================================================================="

if [[ $EUID -ne 0 ]]; then
   echo "[Error] This script must be run as root or with sudo!" 1>&2
   exit 1
fi


while getopts m:p: option
do
        case "${option}"
        in
                m) MY_SQL_BACKUP_PATH=${OPTARG};;
				p) PG_SQL_BACKUP_PATH=${OPTARG};;
        esac
done


if [  -z $MY_SQL_BACKUP_PATH ]; 
then
	echo "[Error] You must specify full paths of mysql and pgsql dumps"
	echo "Example:"
	echo "sudo ./restore-all-dbs.sh -m /backup/mysql-dump.sql -p /backup/pgsql-dump.sql"
	exit 1
fi

if [  -z $PG_SQL_BACKUP_PATH ]; 
then
	echo "[Error] You must specify full paths of mysql and pgsql dumps"
	echo ""
	echo "Example:"
	echo ""
	echo "sudo ./restore-all-dbs.sh -m /backup/mysql-dump.sql -p /backup/pgsql-dump.sql"
	echo ""
	echo "You can also pass files with .gz extension. They will be gunzip-ped." 
	exit 1
fi


if [ ! -f "$MY_SQL_BACKUP_PATH" ]; then
  	echo "Could not find backup file: $MY_SQL_BACKUP_PATH"
	exit 1  	
fi

if [ ! -f "$PG_SQL_BACKUP_PATH" ]; then
  	echo "Could not find backup file: $PG_SQL_BACKUP_PATH"
	exit 1  	
fi


############################### STOP ALL ################################################################

# Bring down Apache Web Server
if is_service_running httpd 
then
	echo "Shutting down httpd service..."
	sudo service httpd stop
fi	

# Bring down Tomcat (Stop Service and Kill Tomcat)
if is_service_running tomcat 
then
	echo "Shutting down tomcat service..."
	sudo service tomcat stop
	sleep 3
	ps aux | grep [t]omcat | awk '{print $2}' | xargs -I PID sudo kill -9 PID
fi	

# Bring down OpenERP
if is_service_running openerp-server
then
	echo "Shutting down openerp service..."
	sudo service openerp stop
	sleep 3
fi	

################################ PERFORM RESTORE ###########################################################


# Perform restore of MYSQL DB
bash $PATH_OF_CURRENT_SCRIPT/restore-mysql.sh $MY_SQL_BACKUP_PATH 

# Perform backup of PostgreSQL DB
bash $PATH_OF_CURRENT_SCRIPT/restore-pgsql.sh $PG_SQL_BACKUP_PATH

echo "========================================="
echo ">> DB RESTORED. CHECK LOGS ABOVE."
echo "========================================="

################################## START ALL ###############################################################
# Start APACHE
if is_service_running httpd 
then
	echo "Warning: HTTPD is already running!!"
else 
	sudo service httpd start
fi	

# Start OpenERP
if is_service_running openerp-server
then
	echo "Warning: OpenERP is already running!!"
else 
	echo ""
	echo "EXECUTE THIS COMMAND TO START OpenERP: sudo service openerp start"
	echo "" 
fi	

# Start Tomcat
if is_service_running tomcat
then
	echo "Warning: Tomcat is already running!!"
else 
	echo ""
	echo "EXECUTE THIS COMMAND TO START TOMCAT: sudo service tomcat start"
	echo "" 
fi	

