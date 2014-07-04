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
service openerp stop

sh $SCRIPTS_DIR/backup-mysql.sh $mysqlRootPassword $BACKUP_DIR
sh $SCRIPTS_DIR/backup-pgsql.sh $BACKUP_DIR

cp -r /home/jss/.OpenMRS $BACKUP_DIR/
cp -r /packages/build $BACKUP_DIR/
cp -r /home/jss/apache-tomcat-7.0.22/webapps $BACKUP_DIR/
cp -r /etc/httpd $BACKUP_DIR/
