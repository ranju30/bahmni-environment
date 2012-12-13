class openmrs ( $tomcatInstallationDirectory, $openmrsDbBackupLocation = "/tmp/openmrsDB" ) {
    exec {"download-openmrs-war" :
            command     => "/usr/bin/wget -O ${tomcatInstallationDirectory}/webapps/openmrs.war http://sourceforge.net/projects/openmrs/files/releases/OpenMRS_1.9.2/openmrs.war",
            timeout     => 0,
            provider    => "shell",
            onlyif      => "test -d ${tomcatInstallationDirectory}"
        }

    exec { "openmrs_db_backup_unzip":
            command     => "unzip /tmp/jss-scm/puppet/modules/openmrs/templates/openmrs.sql.zip -d $openmrsDbBackupLocation",
            user        => "${userName}",
            path        => ["/bin"],
            require     => Exec["download-openmrs-war"],
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