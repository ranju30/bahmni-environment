class openmrs ( $tomcatInstallationDirectory) {
    exec {"download-openmrs-war" :
            command     => "/usr/bin/wget -O ${tomcatInstallationDirectory}/webapps/openmrs.war http://sourceforge.net/projects/openmrs/files/releases/OpenMRS_1.9.2/openmrs.war",
            timeout     => 0,
            provider    => "shell",
			user        => "${jssUser}",
            onlyif      => "test -d ${tomcatInstallationDirectory}"
    }
}
