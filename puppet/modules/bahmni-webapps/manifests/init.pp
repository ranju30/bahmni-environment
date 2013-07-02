class bahmni-webapps {
  require openmrs
  require bahmni-configuration

  $openmrs_modules_dir = "/home/${bahmni_user}/.OpenMRS/modules"

  file { "${openmrs_modules_dir}" :
    owner  => "${bahmni_user}",
    group  =>  "${bahmni_user}",   
    mode   => 664,
    ensure    => directory,
    recurse   => true,
    force     => true,
    purge     => true
  }

  exec { "bahmni_omods" :
    command => "cp ${build_output_dir}/*.omod ${openmrs_modules_dir} ${deployment_log_expression}",
    user    => "${bahmni_user}",
    require => File["${openmrs_modules_dir}"],
    path => "${os_path}"
  }

  exec { "openmrs_omods" :
    command => "cp ${packages_servers_dir}/*.omod ${openmrs_modules_dir} ${deployment_log_expression}",
    user    => "${bahmni_user}",
    require => File["${openmrs_modules_dir}"],
    path => "${os_path}"
  }

  file { "${temp_dir}/run-modules-liquibase.sh" :
    ensure      => present,
    content     => template("bahmni-webapps/run-modules-liquibase.sh"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 554
  }

  exec { "openmrs_modules_data" :
    command     => "${temp_dir}/run-modules-liquibase.sh ${build_output_dir} ${openmrs_modules_dir} ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    cwd         => "${tomcatInstallationDirectory}/webapps",
    require     => [Exec["bahmni_omods"], Exec["openmrs_omods"], File["${temp_dir}/run-modules-liquibase.sh"]]
  }
  
  exec { "email-appender" :
    command => "cp ${build_output_dir}/bahmnicore-mail-appender-${bahmni_version}-jar-with-dependencies.jar ${tomcatInstallationDirectory}/webapps/openmrs/WEB-INF/lib",
    user    => "${bahmni_user}",
    require => File["${openmrs_modules_dir}"],
    path    => "${os_path}"
  }
}