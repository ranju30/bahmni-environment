#!/bin/sh
set -e

mysqlRootPassword=$1

if [ -z $mysqlRootPassword ]; then
    echo "Please provide a password for mysql root"
    echo "[USAGE] $0 <mysqlRootPassword>"
    exit 1
fi

SCRIPTS_DIR=`dirname $0`

TIME=`date +%Y%m%d_%H%M%S`

BACKUP_DIR="/root/release-backups/backup_$TIME"
mkdir -p $BACKUP_DIR
chmod 777 $BACKUP_DIR

set -x

service httpd stop
service tomcat stop
if [ $FACTER_deploy_bahmni_openerp = "true" ]; then
	service openerp stop
fi

sh $SCRIPTS_DIR/backup-mysql.sh $mysqlRootPassword $BACKUP_DIR
sh $SCRIPTS_DIR/backup-pgsql.sh $BACKUP_DIR

cp -r /home/bahmni/.OpenMRS $BACKUP_DIR/
cp -r /packages $BACKUP_DIR/
cp -r /home/bahmni/apache-tomcat-8.0.12/webapps $BACKUP_DIR/
cp -r /etc/httpd $BACKUP_DIR/
cp -r /usr/lib/python2.6/site-packages $BACKUP_DIR/