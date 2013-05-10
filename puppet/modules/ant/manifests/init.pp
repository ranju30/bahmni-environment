class ant {
	exec { "ant_untar" :
	  command => "tar zxf ${package_dir}/tools/apache-ant*.tar.gz ${deployment_log_expression}",
	  user    => "${jssUser}",
	  cwd     => "/home/${jssUser}",
	  creates => "${ant_home}",
	  path    => "${os_path}"
	}
}