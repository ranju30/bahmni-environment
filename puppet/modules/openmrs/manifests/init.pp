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
    
    file { "/home/${jssUser}/.OpenMRS/openerp.properties" :
        ensure      => present,
        content     => template("openmrs/openerp.properties.erb"),
        owner       => "${jssUser}",
        group       => "${jssUser}",
        require    => Exec["install-openmrs"],
    }

    exec {"restart_tomcat" :
          command     => "/etc/init.d/tomcat restart",
          user        => "${jssUser}",
          require		=> Exec["install-openmrs"],
  	}

    file { "$tomcatInstallationDirectory/webapps/openmrs/WEB-INF/classes/log4j.xml" :
        ensure      => present,
        content     => template("openmrs/log4j.xml.erb"),
        owner       => "${jssUser}",
        group       => "${jssUser}",
        require    => Exec["restart_tomcat"],
    }
}
