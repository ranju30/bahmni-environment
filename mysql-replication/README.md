* Clone this repo on both master and slave

* On Master
 	* Update the replication.properties file with both master and slave information
	* cd mysql-replication && sudo ./master.sh
	* Note the value for log_file and log_pos

* On slave
	* Copy the master dump file to slave: scp root@master-host:/tmp/bahmni-environment/mysql-replication/mysql_master_dump.db /tmp
	* Update the replication.properties file with both master and slave information
	* cd mysql-replication && sudo ./slave.sh
	