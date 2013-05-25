# mysql replication
# Master Properties
$musername="root"
$mpassword="password"
$mhost="192.168.2.19"
$masterServerId="100"
$expireLogsDays="90"

# Slave Properties 
$susername="root"
$spassword="password"
$shost="192.168.2.9"
$slaveServerId="101"
$mysqlMachine="slave"

$master_dump_file="/tmp/mysql_master_dump.db"
$log_file="mysql-bin.000001"
$log_pos="467"

#postgres replication
$postgresMachine = "slave"
$postgresMaster = "192.168.2.19"
$postgresSlave = "192.168.2.9"

$postgresFirstTimeSetup="true # Use this for first time setup of master and slave"
$postgresMasterDbFileBackup="/tmp/pg_master_db_file_backup.tar" # The path of master db backup tar file on slave
