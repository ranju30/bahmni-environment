class openmrs ( $tomcatInstallationDirectory) {
    exec {"download-openmrs-war" :
        command     => "/usr/bin/wget -O /tmp/openmrs-${openMRSVersion}.war http://sourceforge.net/projects/openmrs/files/releases/OpenMRS_${openMRSVersion}/openmrs.war",
        timeout     => 0,
        provider    => "shell",
        user        => "${jssUser}",
        onlyif      => "! test -f /tmp/openmrs-${openMRSVersion}.war"
    }

    exec {"install-openmrs" :
        command     => "cp /tmp/openmrs-${openMRSVersion}.war ${tomcatInstallationDirectory}/webapps/openmrs.war",
        user        => "${jssUser}",
        onlyif      => "test -d ${tomcatInstallationDirectory}",
        require		=> Exec["download-openmrs-war"],
    }

    file { "${imagesDirectory}" :
        ensure      => directory,
        owner       => "${jssUser}",
        group       => "${jssUser}",
    }

	 file { "$tomcatInstallationDirectory/webapps/patient_images":
       ensure => "link",
       target => "${imagesDirectory}",
       require => File["${imagesDirectory}"],
    }

    file { "/home/${jssUser}/.OpenMRS" :
        ensure      => directory,
        owner       => "${jssUser}",
        group       => "${jssUser}",
        require    => Exec["install-openmrs"],
    }

    file { "/home/${jssUser}/.OpenMRS/bahmnicore.properties" :
        ensure      => present,
        content     => template("openmrs/bahmnicore.properties.erb"),
        owner       => "${jssUser}",
        group       => "${jssUser}",
        require    => File["/home/${jssUser}/.OpenMRS"],
    }

    exec {"restart_tomcat" :
        command     => "/etc/init.d/tomcat restart",
        user        => "${jssUser}",
        require		=> Exec["install-openmrs"],
  	}

    file {"$tomcatInstallationDirectory/webapps/openmrs" :
        ensure      => "directory",
        owner       => "${jssUser}",
        group       => "${jssUser}",
        require    => Exec["restart_tomcat"],
    }

    file { "${tomcatInstallationDirectory}/webapps/openmrs/WEB-INF/classes/log4j.xml" :
        ensure      => present,
        content     => template("openmrs/log4j.xml.erb"),
        owner       => "${jssUser}",
        group       => "${jssUser}",
        require    => File["${tomcatInstallationDirectory}/webapps/openmrs"],
    }

    file { "$tomcatInstallationDirectory/webapps/openmrs/WEB-INF/web.xml" :
        ensure      => present,
        content     => template("openmrs/web.xml"),
        owner       => "${jssUser}",
        group       => "${jssUser}",
        require    => File["${tomcatInstallationDirectory}/webapps/openmrs/WEB-INF/classes/log4j.xml"],
    }
}
