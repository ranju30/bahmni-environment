#!/bin/sh
DB_PASSWORD=$1

NOW=`date +%Y%d%m%H%M`
BACKUPFILE=/tmp/mysql_dump${NOW}.sql
rm -f $BACKUPFILE

mysqldump -uroot -p$DB_PASSWORD --all-databases > $BACKUPFILE
service mysqld stop

yum -vq remove mysql.x86_64 mysql-libs.x86_64 mysql-server.x86_64
yum -vqy install MySQL-server.x86_64 MySQL-shared.x86_64 MySQL-shared-compat.x86_64 MySQL-client.x86_64 

mysql_upgrade -uroot -p$DB_PASSWORD

mysql -uroot -p$DB_PASSWORD < $BACKUPFILE

service mysql start