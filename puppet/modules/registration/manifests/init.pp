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
  }

  # Mujir - with recurse this takes a long time. The exec resource below speeds this up
  file { "registrationAppDirectory exists" :
    path        => "${registrationAppDirectory}",
    ensure      => directory,
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 664,
    require     => Exec["deploy_registration"],
  }
  exec { "change_rights_for_registration_dir" :
    provider => "shell",
    command => "chown -R ${bahmni_user}:${bahmni_user} ${registrationAppDirectory}; chmod -R 664 ${registrationAppDirectory}; umask 223;",
    path => "${os_path}",
    require => File["registrationAppDirectory exists"],
  }


  exec { "deploy_opd" :
    command   => "unzip -q -o ${build_output_dir}/opd.zip -d ${opdAppDirectory} ${deployment_log_expression}",
    provider  => shell,
    path    => "${os_path}",
  }

  # Mujir - with recurse this takes a long time. The exec resource below speeds this up
  file { "opdAppDirectory exists" :
    path        => "${opdAppDirectory}",
    ensure      => directory,
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 664,
    require     => Exec["deploy_opd"],
  }
  exec { "change_rights_for_opd_dir" :
    provider => "shell",
    command => "chown -R ${bahmni_user}:${bahmni_user} ${opdAppDirectory}; chmod -R 664 ${opdAppDirectory}; umask 223;",
    path => "${os_path}",
    require => File["opdAppDirectory exists"],
  }

}