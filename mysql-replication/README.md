* Clone this repo on both master and slave

* On Master
 	* Update the replication.properties file with both master and slave information
	* cd mysql-replication/$version && sudo ./master.sh
	* Note the value for log_file and log_pos

* On slave
	* Copy the master dump file to slave: scp root@master-host:/tmp/bahmni-environment/mysql-replication/${version}/mysql_master_dump.db /tmp
	* Update the replication.properties file with both master and slave information
	* Use command 'show master status' to get the current position of the server and update in slave replication.properties
	* cd mysql-replication/$version && sudo ./slave.sh
	* Note: Need privileges to access the database, Grant privilege to the Slave IP Address