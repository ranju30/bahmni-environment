class tomcat::clean inherits tomcat::config {
    exec { "remove_work_and_temp":
     	command => "rm -rf ${::config::tomcatInstallationDirectory}/work ${::config::tomcatInstallationDirectory}/temp ${::config::deployment_log_expression}",
	    path => "${config::os_path}",
	    user => "${::config::bahmni_user}"
    } 
}