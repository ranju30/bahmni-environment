class maven inherits maven::config {

	require users

	exec { "remove_maven" :
		command => "rm -rf /home/${::config::bahmni_user}/apache-maven*",
		path 		=> "${config::os_path}",
		user 		=> "${::config::bahmni_user}",
		creates   => "/home/${::config::bahmni_user}/apache-maven*"

	}

	exec { "maven_untar" :
	  command => "tar zxf ${::config::package_dir}/tools/apache-maven*.tar.gz   ${::config::deployment_log_expression}",
	  user    => "${::config::bahmni_user}",
	  cwd     => "/home/${::config::bahmni_user}",
	  creates => "${maven_home}",
	  path    => "${config::os_path}",
	  require => Exec["remove_maven"]
	}
}