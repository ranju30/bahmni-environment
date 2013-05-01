class tomcat-runtime {
	require tomcat
	require openmrs

  $log_file = "${logs_dir}/tomcat-runtime-module.log"
  $log_expression = ">> ${log_file} 2>> ${log_file}"

  file { "${log_file}" :
    ensure        => absent,
    purge         => true
  }

	exec { "catalina" :
    command     => "sh ${tomcatInstallationDirectory}/bin/catalina.sh start ${log_expression}",
		user        => "${bahmni_user}",
    provider    => "shell",
    path        => "${os_path}"
	}

  file { "${temp_dir}/start-tomcat-webapp.sh" :
    content     => template("tomcat-runtime/start-tomcat-webapp.sh"),
    owner       => "${bahmni_user}",
		mode       	=>  544
  }

	exec { "start openmrs" :
		command 		=> "sh ${temp_dir}/start-tomcat-webapp.sh http://localhost:${tomcatHttpPort}/openmrs ${log_expression}",
    user        => "${bahmni_user}",
    path        => "${os_path}",
    require			=> [File["${temp_dir}/start-tomcat-webapp.sh"], Exec["catalina"]],
    timeout			=> 30
	}
}