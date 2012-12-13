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

    exec {"download-openmrs-database-backup" :
            command     => "/usr/bin/wget -O ${openmrsDbBackupLocation}/openmrs.sql.zip https://www.dropbox.com/s/91490s8ofkbwy49/openmrs.sql.zip",
            timeout     => 0,
            provider    => "shell",
            require     => Exec["delete-openmrs-files"]
         }

    exec { "openmrs_db_backup_unzip":
            command     => "unzip ${openmrsDbBackupLocation}/openmrs.sql.zip -d $openmrsDbBackupLocation",
            user        => "${userName}",
            path        => ["/bin"],
            require     => Exec["download-openmrs-database-backup"],
            provider    => "shell",
        }

    exec { "openmrs_update_db":
            command     => "mysql -uroot -p${mysqlRootPassword} < ${openmrsDbBackupLocation}/openmrs.sql",
            user        => "${userName}",
            path        => ["/usr/bin"],
            require     => Exec["openmrs_db_backup_unzip"],
            provider    => "shell",
        }


}