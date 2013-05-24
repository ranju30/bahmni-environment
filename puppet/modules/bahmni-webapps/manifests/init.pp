class bahmni-webapps {
  require openmrs
  require bahmni-configuration

  $openmrs_modules_dir = "/home/${bahmni_user}/.OpenMRS/modules"

  file { "${openmrs_modules_dir}" :
    owner  => "${bahmni_user}",
    mode   => 644,
    ensure    => directory,
    recurse   => true,
    force     => true,
    purge     => true
  }

  exec { "omods" :
    command => "cp ${build_output_dir}/*.omod ${openmrs_modules_dir} ${deployment_log_expression}",
    user    => "${bahmni_user}",
    require => File["${openmrs_modules_dir}"],
    path => "${os_path}"
  }
  
  exec { "email-appender" :
    command => "cp ${build_output_dir}/bahmnicore-mail-appender-0.2-SNAPSHOT-jar-with-dependencies.jar ${tomcatInstallationDirectory}/webapps/openmrs/WEB-INF/lib",
    user    => "${bahmni_user}",
    require => File["${openmrs_modules_dir}"],
    path    => "${os_path}"
  }

  # $deploy_temp_dir = "${temp_dir}/deploy"

  # file { "${deploy_temp_dir}" :
  #   ensure => directory,
  #   mode   => 666,
  #   owner  => "${bahmni_user}"
  # }

  # file { "${deploy_temp_dir}/wait-for-webapp-load.sh" :
  #   content     => template("bahmni-webapps/wait-for-webapp-load.sh"),
  #   owner       => "${bahmni_user}",
  #   mode        =>  544,
  #   require     => File["${deploy_temp_dir}"]
  # }

  # exec { "catalina_start" :
  #   command     => "sh ${tomcatInstallationDirectory}/bin/catalina.sh start ${deployment_log_expression}",
  #   user        => "${bahmni_user}",
  #   provider    => shell,
  #   path        => "${os_path}"
  # }

  # define wait_till_webapps_loads {
  #   exec { "wait_till_${title}_loads" :
  #     command     => "sh ${deploy_temp_dir}/wait-for-webapp-load.sh http://localhost:${tomcatHttpPort}/${title} ${deployment_log_expression}",
  #     user        => "${bahmni_user}",
  #     path        => "${os_path}",
  #     require     => [File["${deploy_temp_dir}/wait-for-webapp-load.sh"], Exec["catalina_start"]],
  #     timeout     => 180
  #   }
  # }
  # wait_till_webapps_loads { ["openmrs", "jasperserver"]: }

  # file { "deploy-openmrs-modules.sh" :
  #   ensure      => present,
  #   content     => template("bahmni-webapps/deploy-openmrs-modules.sh"),
  #   path 				=> "${deploy_temp_dir}/deploy-openmrs-modules.sh",
  #   owner       => "${bahmni_user}",
  #   mode        => 544,
  #   require     => File["${deploy_temp_dir}"]
  # }

  # exec { "webservices.rest-1.2-SNAPSHOT" :
  #   command   => "cp ${build_output_dir}/webservices.rest-1.2-SNAPSHOT*.omod ${deploy_temp_dir}/webservices.rest-1.2-SNAPSHOT.omod ${deployment_log_expression}",
  #   path      => "${os_path}",
  #   provider  => shell
  # }

  # exec { "deploy_openmrs_modules" :
  #   command   => "sh deploy-openmrs-modules.sh ${openmrs_password} http://localhost:${tomcatHttpPort}/openmrs webservices.rest-1.2-SNAPSHOT.omod ${build_output_dir}/addresshierarchy-2.2.10-SNAPSHOT.omod ${build_output_dir}/idgen-2.4.1.omod ${build_output_dir}/bahmnicore-0.2-SNAPSHOT.omod ${deployment_log_expression}",
  #   provider  => shell,
  #   path      => "${os_path}",
  #   require   => [File["deploy-openmrs-modules.sh"], Exec["wait_till_openmrs_loads"], Exec["webservices.rest-1.2-SNAPSHOT"]],
  #   cwd       => "${deploy_temp_dir}"
  # }
}