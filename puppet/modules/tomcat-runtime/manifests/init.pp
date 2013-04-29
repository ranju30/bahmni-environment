class tomcat-runtime {
	exec {"start_tomcat" :
		command     => "sh /etc/init.d/tomcat restart",
		user        => "${bahmni_user}",
		path 				=> "${os_path}"
	}

  file { "start-tomcat-webapp.sh" :
    path        => "${temp_dir}/start-tomcat-webapp.sh",
    content     => template("tomcat-runtime/start-tomcat-webapp.sh"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
		mode       	=>  764
  }

	exec { "start openmrs" :
		command 		=> "sh ${temp_dir}/start-tomcat-webapp.sh http://localhost:${tomcatHttpPort}/openmrs",
    user        => "${bahmni_user}",
    path        => "$os_path"
	}
}