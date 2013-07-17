#!/bin/sh
set -e -x

BASE_DIR=`dirname $0`

# MySQL Slave machine configuration
. $BASE_DIR/replicator.sh

echo "Modifying/Inserting required properties"
cp /etc/my.cnf /tmp/my.cnf
findAndReplace "log_bin" "\/var\/log\/mysql\/mysql-bin.log"
findAndReplace "server-id" "$slaveServerId"

mv /etc/my.cnf /etc/my.cnf.repl.bak
mv /tmp/my.cnf /etc/my.cnf

echo "Creating mysql-bin file"
mkdir -p /var/log/mysql/
touch /var/log/mysql/mysql-bin.log
chmod -R 777 /var/log/mysql

stopMySQL

rm -f /var/lib/mysql/*relay-bin*
rm -f /var/lib/mysql/*relay-log.info
rm -f /var/lib/mysql/master.info

echo "Starting MySQL in safe mode.."
service mysql start --skip-slave-start & 2> /dev/null

sleep 2
dumpFileExists=`ls -l $master_dump_file`

if [ "$?" != "0" ]; then echo "Dump file not found. Expected file : $master_dump_file"; exit 1; fi

echo "Restoring dump from file."
mysql -uroot -p$spassword < $master_dump_file
echo "Restore complete."

stopMySQL

service mysql start --skip-slave-start --skip-grant-tables & 2> /dev/null

echo "Changing root user privileges"
sleep 1
mysql -uroot -e "update mysql.user set password=PASSWORD('$spassword') where User = 'root'"
mysql -uroot -e "flush privileges"

stopMySQL

sleep 2
service mysql start --skip-slave-start & 2> /dev/null

sleep 2
mysql -uroot -p$spassword -e "RESET MASTER"
mysql -uroot -p$spassword -e "CHANGE MASTER TO MASTER_HOST='$mhost', MASTER_USER='$susername', MASTER_PASSWORD='$spassword', MASTER_LOG_FILE='$log_file', MASTER_LOG_POS=$log_pos"

stopMySQL

service mysql start

mysql -uroot -p$spassword -e "show processlist"
mysql -uroot -p$spassword -e "show slave status"
mysql -uroot -p$spassword -e "show status like 'Slave%'"

