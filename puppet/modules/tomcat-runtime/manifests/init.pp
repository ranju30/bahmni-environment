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
    command     => "sh ${tomcatInstallationDirectory}/bin/catalina.sh stop ${log_expression}",
    user        => "${bahmni_user}",
    provider    => shell,
    path        => "${os_path}"
  }

  file { "${temp_dir}/start-tomcat-webapp.sh" :
    content     => template("tomcat-runtime/start-tomcat-webapp.sh"),
    owner       => "${bahmni_user}",
		mode       	=>  544
  }
}