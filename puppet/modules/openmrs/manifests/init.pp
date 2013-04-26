class openmrs ($tomcatInstallationDirectory) {
    exec {"download-openmrs-war" :
        command     => "/usr/bin/wget -O /tmp/openmrs-${openMRSVersion}.war http://sourceforge.net/projects/openmrs/files/releases/OpenMRS_${openMRSVersion}/openmrs.war",
        timeout     => 0,
        provider    => "shell",
        user        => "${bahmni_user}",
        onlyif      => "! test -f /tmp/openmrs-${openMRSVersion}.war"
    }

    exec {"install-openmrs" :
        command     => "cp /tmp/openmrs-${openMRSVersion}.war ${tomcatInstallationDirectory}/webapps/openmrs.war",
        user        => "${bahmni_user}",
        onlyif      => "test -d ${tomcatInstallationDirectory}",
        require		=> Exec["download-openmrs-war"],
    }

    file { "${imagesDirectory}" :
        ensure      => directory,
        owner       => "${bahmni_user}",
        group       => "${bahmni_user}",
    }

	 file { "$tomcatInstallationDirectory/webapps/patient_images" :
       ensure => "link",
       target => "${imagesDirectory}",
       require => File["${imagesDirectory}"],
    }

    file { "/home/${bahmni_user}/.OpenMRS" :
        ensure      => directory,
        owner       => "${bahmni_user}",
        group       => "${bahmni_user}",
        require    => Exec["install-openmrs"],
    }

    file { "/home/${bahmni_user}/.OpenMRS/bahmnicore.properties" :
        ensure      => present,
        content     => template("openmrs/bahmnicore.properties.erb"),
        owner       => "${bahmni_user}",
        group       => "${bahmni_user}",
        require    => File["/home/${bahmni_user}/.OpenMRS"],
    }

    exec {"restart_tomcat" :
        command     => "/etc/init.d/tomcat restart",
        user        => "${bahmni_user}",
        require		=> Exec["install-openmrs"],
  	}

    file {"$tomcatInstallationDirectory/webapps/openmrs" :
        ensure      => "directory",
        owner       => "${bahmni_user}",
        group       => "${bahmni_user}",
        require    => Exec["restart_tomcat"],
    }

    file { "${tomcatInstallationDirectory}/webapps/openmrs/WEB-INF/classes/log4j.xml" :
        ensure      => present,
        content     => template("openmrs/log4j.xml.erb"),
        owner       => "${bahmni_user}",
        group       => "${bahmni_user}",
        require    => File["${tomcatInstallationDirectory}/webapps/openmrs"],
    }

    file { "$tomcatInstallationDirectory/webapps/openmrs/WEB-INF/web.xml" :
        ensure      => present,
        content     => template("openmrs/web.xml"),
        owner       => "${bahmni_user}",
        group       => "${bahmni_user}",
        require    => File["${tomcatInstallationDirectory}/webapps/openmrs/WEB-INF/classes/log4j.xml"],
    }
}