class tomcat-runtime {
	require tomcat
	require openmrs

  $log_file = "${logs_dir}/tomcat-runtime-module.log"
  $log_expression = ">> ${log_file} 2>> ${log_file}"

  file { "${log_file}" :
    ensure        => absent,
    purge         => true
  }

	exec { "start_tomcat" :
    command     => "sh ${tomcatInstallationDirectory}/bin/catalina.sh start ${log_expression}",
		user        => "${bahmni_user}",
    provider    => "shell",
    path        => "${os_path}"
	}

  file { "start-tomcat-webapp.sh" :
    path        => "${temp_dir}/start-tomcat-webapp.sh",
    content     => template("tomcat-runtime/start-tomcat-webapp.sh"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
		mode       	=>  764
  }

	exec { "start openmrs" :
		command 		=> "sh ${temp_dir}/start-tomcat-webapp.sh http://localhost:${tomcatHttpPort}/openmrs ${log_expression}",
    user        => "${bahmni_user}",
    path        => "${os_path}",
    require			=> File["start-tomcat-webapp.sh"],
    timeout			=> 30
	}
}