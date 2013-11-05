#!/bin/sh
set -e -x
rootPassword=$1

if [ -z $rootPassword ]; then
	echo "Please provide a password for mysql root"
	exit 1
fi	

TIME=`date +%Y%m%d_%H%M%S`
mysqldump -uroot -p$rootPassword --all-databases --routines | gzip > /backup/mysql_backup_$TIME.sql.gz