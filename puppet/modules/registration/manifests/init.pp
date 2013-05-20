class registration {
	file { "${registrationAppDirectory}" :
    ensure    => absent,
    recurse   => true,
    force     => true,
    purge     => true
	}

  exec { "deploy_registration" :
    command   => "unzip -q -o ${build_output_dir}/registration.zip -d ${registrationAppDirectory} ${deployment_log_expression}",
    provider  => shell,
    path 			=> "${os_path}",
    require   => File["${registrationAppDirectory}"]
  }
}