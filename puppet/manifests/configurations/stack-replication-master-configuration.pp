# mysql replication
# Master Properties
$mysqlMachine="master"
$musername="root"
$mpassword="password"
$mhost="192.168.3.10"
$masterServerId="100"
$expireLogsDays="90"

# Slave Properties 
$susername="root"
$spassword="password"
$shost="192.168.3.15"
$slaveServerId="101"

$master_dump_file="/tmp/mysql_master_dump.db"
$log_file="mysql-bin.000001"
$log_pos="467"

#postgres replication
$postgresMachine = "master"
$postgresMaster = "192.168.3.10"
$postgresSlave = "192.168.3.15"

$postgresFirstTimeSetup=true # Use this for first time setup of master and slave
$postgresMasterDbFileBackup="/tmp/pg_master_db_file_backup.tar" # The path of master db backup tar file on slave
