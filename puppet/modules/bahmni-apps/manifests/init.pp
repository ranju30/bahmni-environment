class bahmni-apps {
	file { "${bahmniAppsAppDirectory}" :
    ensure    => absent,
    recurse   => true,
    force     => true,
    purge     => true
	}

  exec { "deploy_bahmni-apps" :
    command   => "unzip -q -o ${build_output_dir}/bahmni-apps.zip -d ${bahmniAppsAppDirectory} ${deployment_log_expression}",
    provider  => shell,
    path 			=> "${os_path}",
    require   => File["${bahmniAppsAppDirectory}"]
  }
}