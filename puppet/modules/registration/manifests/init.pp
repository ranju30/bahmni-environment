class registration {
  file { "${httpd_deploy_dir}" :
    ensure      => directory,
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 775,
  }

  exec { "change_rights_for_httpd_deploy_dir" :
    provider => "shell",
    command => "chown -R ${bahmni_user}:${bahmni_user} ${httpd_deploy_dir}; chmod -R ug+w,a+r ${httpd_deploy_dir}",
    path => "${os_path}",
    require => File["${httpd_deploy_dir}"],
  }

  exec { "deploy_registration" :
    command   => "unzip -q -o ${build_output_dir}/registration.zip -d ${registrationAppDirectory} ${deployment_log_expression}",
    provider  => shell,
    path 	  => "${os_path}",
  }

  exec { "deploy_opd" :
    command   => "unzip -q -o ${build_output_dir}/opd.zip -d ${opdAppDirectory} ${deployment_log_expression}",
    provider  => shell,
    path    => "${os_path}",
  }
}