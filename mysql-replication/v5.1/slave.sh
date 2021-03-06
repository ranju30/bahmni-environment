#!/bin/sh

BASE_DIR=`dirname $0`

# MySQL Slave machine configuration
. $BASE_DIR/replicator.sh

echo "Modifying/Inserting required properties"
cp /etc/my.cnf /tmp/my.cnf
findAndReplace "bind-address" "0.0.0.0"
findAndReplace "log_bin" "\/var\/log\/mysql\/mysql-bin.log"
findAndReplace "server-id" "$slaveServerId"

#moving the file changes the SELinux file context. Hence copying and removing
cp /etc/my.cnf /etc/my.cnf.repl.bak
rm -rf /etc/my.cnf
cp /tmp/my.cnf /etc/my.cnf
rm -rf /tmp/my.cnf
chown mysql:mysql /etc/my.cnf

echo "Creating mysql-bin file"
mkdir -p /var/log/mysql/
touch /var/log/mysql/mysql-bin.log
chmod -R 777 /var/log/mysql

stopMySQL

echo "Starting MySQL in safe mode.."
mysqld_safe --skip-slave-start & 2> /dev/null

sleep 2
dumpFileExists=`ls -l $master_dump_file`

if [ "$?" != "0" ]; then echo "Dump file not found. Expected file : $master_dump_file"; exit 1; fi

echo "Restoring dump from file."
mysql -uroot -p$spassword < $master_dump_file
echo "Restore complete."

stopMySQL

mysqld_safe --skip-slave-start --skip-grant-tables & 2> /dev/null

echo "Changing root user privileges"
sleep 1
mysql -uroot -e "update mysql.user set password=PASSWORD('$spassword') where User = 'root'"
mysql -uroot -e "flush privileges"

stopMySQL

sleep 2
mysqld_safe --skip-slave-start & 2> /dev/null

sleep 2
mysql -uroot -p$spassword -e "RESET MASTER"
mysql -uroot -p$spassword -e "CHANGE MASTER TO MASTER_HOST='$mhost', MASTER_USER='$susername', MASTER_PASSWORD='$spassword', MASTER_LOG_FILE='$log_file', MASTER_LOG_POS=$log_pos"

stopMySQL

/sbin/service mysqld start

mysql -uroot -p$spassword -e "show processlist"
mysql -uroot -p$spassword -e "show slave status"
mysql -uroot -p$spassword -e "show status like 'Slave%'"

