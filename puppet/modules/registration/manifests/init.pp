class registration {

  # file { "${registrationAppDirectory}" :
  #   ensure    => absent,
  #   recurse   => true,
  #   force     => true,
  #   purge     => true
  # }

  exec { "deploy_registration" :
    command   => "unzip -q -o ${build_output_dir}/registration.zip -d ${registrationAppDirectory} ${deployment_log_expression}",
    provider  => shell,
    path 	  => "${os_path}",
    require   => File["${registrationAppDirectory}"]
  }

  file { "registrationAppDirectory exists" :
    path        => "${registrationAppDirectory}",
    ensure      => directory,
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 664,
    recurse     => true,
  }
}