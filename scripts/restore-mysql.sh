#!/bin/sh
set -e -x
dumpfile=$1

if [ -z $dumpfile ]; then
	echo "Please specify sql dump file"
	exit 1
fi

mysql -uroot -ppassword  -e "show databases" | grep -v Database | grep -v mysql| grep -v information_schema| grep -v test | grep -v OLD |gawk '{print "drop database " $1 ";select sleep(0.1);"}' | mysql -uroot -ppassword
mysql -uroot -ppassword < $dumpfile