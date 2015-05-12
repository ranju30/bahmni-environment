* Clone this repo on both master and slave

* On Master
 	* Update /etc/bahmni/bahmni.properties file with both master and slave information
		* Change value of is_passive_setup to false
	* Run the puppet using provision.pp
	* This will output tar file : /tmp/pg_master_db_file_backup.tar

* On slave
	* Copy the tar file to slave: scp root@master-host:/tmp/pg_master_db_file_backup.tar /tmp
 	* Update /etc/bahmni/bahmni.properties file with both master and slave information
		* Change value of is_passive_setup to true
	* Run the puppet using provision.pp
