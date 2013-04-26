class openmrs-demo-data ($openmrsDbBackupLocation = "/tmp/openmrsDB" ) {
    file { "ensure_openmrsdb_directory" :
            ensure  => "directory",
            path    => "${openmrsDbBackupLocation}",
            purge   => true,
            recurse => true,
            require => Exec["download-openmrs-war"]
         }

    file { "delete_openmrs_dir":
            ensure  => absent,
            path    => "/home/${bahmni_user}/.OpenMRS",
            force   => true,
	     }

    exec {"download-openmrs-database-backup" :
            command     => "/usr/bin/wget -O ${openmrsDbBackupLocation}/openmrs.sql.zip https://dl.dropbox.com/s/ne6ph52js2gx3n9/openmrs_withconcepts.sql.zip?dl=1",
            timeout     => 0,
            provider    => "shell",
			user        => "${bahmni_user}",
            require     => File["ensure_openmrsdb_directory"]
         }

    exec { "openmrs_db_backup_unzip":
            command     => "unzip ${openmrsDbBackupLocation}/openmrs.sql.zip -d $openmrsDbBackupLocation",
            path        => ["/usr/bin"],
			user        => "${bahmni_user}",
            require     => Exec["download-openmrs-database-backup"],
        }

    exec { "openmrs_update_db":
            command     => "mysql -uroot -p${mysqlRootPassword} openmrs < ${openmrsDbBackupLocation}/openmrs.sql",
            path        => ["/usr/bin"],
			user        => "${bahmni_user}",
			timeout     => 0,
            require     => Exec["openmrs_db_backup_unzip"],
        }

    exec { "get_openMRS_folder" :
            command     => "/usr/bin/wget -O /home/${bahmni_user}/.OpenMRS.zip https://dl.dropbox.com/s/wd1900mwue3nu8n/.OpenMRS.zip?dl=1",
            timeout     => 0,
			user        => "${bahmni_user}",
            provider    => "shell",
         }

    exec { "openMRS_folder_unzip":
            command     => "unzip /home/${bahmni_user}/.OpenMRS.zip -d /home/${bahmni_user}",
            path        => ["/usr/bin"],
			user        => "${bahmni_user}",
            require     => [Exec["get_openMRS_folder"], File["delete_openmrs_dir"]],
         }

    exec { "change_openMRS_folder_ownership" :
             command     => "/bin/chown -R ${bahmni_user}:${bahmni_user} /home/${bahmni_user}/.OpenMRS",
             require     => Exec["openMRS_folder_unzip"],
         }

}
