class openmrs ( $tomcatInstallationDirectory, $openmrsDbBackupLocation = "/tmp/openmrsDB" ) {
    exec {"download-openmrs-war" :
            command     => "/usr/bin/wget -O ${tomcatInstallationDirectory}/webapps/openmrs.war http://sourceforge.net/projects/openmrs/files/releases/OpenMRS_1.9.2/openmrs.war",
            timeout     => 0,
            provider    => "shell",
            onlyif      => "test -d ${tomcatInstallationDirectory}"
        }

    file { "ensure_openmrsdb_directory" :
            ensure  => "directory",
            path    => "${openmrsDbBackupLocation}",
            purge   => true,
            recurse => true,
            require => Exec["download-openmrs-war"]
         }

    file { "delete_openmrs_dir":
            ensure  => absent,
            path    => "/home/${jssUser}/.OpenMRS",
            force   => true,
	     }

    exec {"download-openmrs-database-backup" :
            command     => "/usr/bin/wget -O ${openmrsDbBackupLocation}/openmrs.sql.zip https://dl.dropbox.com/sh/n4rxhk1pj0vi66h/J9CpTgvopG/openmrs.sql.zip?dl=1",
            timeout     => 0,
            provider    => "shell",
            require     => File["ensure_openmrsdb_directory"]
         }

    exec { "openmrs_db_backup_unzip":
            command     => "unzip ${openmrsDbBackupLocation}/openmrs.sql.zip -d $openmrsDbBackupLocation",
            path        => ["/usr/bin"],
            require     => Exec["download-openmrs-database-backup"],
        }

    exec { "openmrs_update_db":
            command     => "mysql -uroot -p${mysqlRootPassword} < ${openmrsDbBackupLocation}/openmrs.sql",
            path        => ["/usr/bin"],
            require     => Exec["openmrs_db_backup_unzip"],
        }

    exec { "get_openMRS_folder" :
            command     => "/usr/bin/wget -O /home/${jssUser}/.OpenMRS.zip https://dl.dropbox.com/s/wd1900mwue3nu8n/.OpenMRS.zip?dl=1",
            timeout     => 0,
            provider    => "shell",
         }

    exec { "openMRS_folder_unzip":
            command     => "unzip /home/${jssUser}/.OpenMRS.zip -d /home/${jssUser}",
            path        => ["/usr/bin"],
            require     => [Exec["get_openMRS_folder"], File["delete_openmrs_dir"]],
         }
}
