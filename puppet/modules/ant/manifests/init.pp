class ant inherits ant::config {

	exec { "remove_ant" :
		command => "rm -rf /home/${config::bahmni_user}/apache-ant*",
		path 		=> "${config::os_path}",
		user 		=> "${config::bahmni_user}"
	}

	exec { "ant_untar" :
	  command => "tar zxf ${config::package_dir}/tools/apache-ant-${config::ant_version}-bin.tar.gz ${config::deployment_log_expression}",
	  user    => "${config::bahmni_user}",
	  cwd     => "/home/${config::bahmni_user}",
	  creates => "${config::ant_home}",
	  path    => "${config::os_path}",
	  require => Exec["remove_ant"]
	}

  file { "ant_home_path" :
  	path    => "/etc/profile.d/ant.sh",
	  ensure  => present,
	  content => template ("ant/ant.sh"),
	  mode    => 664,
	  require => Exec["ant_untar"]
	}


  exec { "set_permissions_of_ant" :
    provider => "shell",
    command => "chmod -R  777 /home/${config::bahmni_user}/apache-ant-${config::ant_version}",
    path => "${config::os_path}",
    require => Exec["ant_untar"]
  }
}