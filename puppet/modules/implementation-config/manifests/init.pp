class implementation-config($implementationName) {

  $implementationZipFile = "${build_output_dir}/${implementationName}_config.zip"
  $migrationsDirectory = "${implementationName}_config/migrations"
  $configDirectory = "${implementationName}_config/openmrs"

  file { "${implementationZipFile}" :
    ensure    => present
  }

  file { "${build_output_dir}/${implementationName}_config" :
    ensure    => absent,
    recurse   => true,
    force     => true,
    purge     => true
  }

  exec { "unzip_${implementationName}" :
    command   => "unzip -q -o $implementationZipFile -d ${build_output_dir}/${implementationName}_config ${deployment_log_expression}",
    provider  => shell,
    path      => "${os_path}",
    require   => [File["${implementationZipFile}"], File["${build_output_dir}/${implementationName}_config"]]
  }
  
  file { "${temp_dir}/run-implementation-liquibase.sh" :
    ensure      => present,
    content     => template("implementation-config/run-implementation-liquibase.sh"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 554
  }

  exec { "run_implementation_liquibase_migration" :
    command     => "${temp_dir}/run-implementation-liquibase.sh  ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    cwd         => "${build_output_dir}/${migrationsDirectory}",
    require     => [Exec["unzip_${implementationName}"],File["${temp_dir}/run-implementation-liquibase.sh"]]
  }

  file { "${httpd_deploy_dir}/bahmni_config" :
    ensure    => directory,
    recurse   => true,
    force     => true,
    purge     => true
  }
  
  exec { "copy_implementation_config" :
    command     => "unzip -q -o $implementationZipFile openmrs/* -d ${httpd_deploy_dir}/bahmni_config ${deployment_log_expression}",
    provider    => "shell",
    path        => "${os_path}",
    require     => [Exec["unzip_${implementationName}"], File["${httpd_deploy_dir}/bahmni_config"]]
  }

  exec { "set_owner_of_bahmni_config" :
    provider => "shell",
    command => "chown -R ${bahmni_user}:${bahmni_user} ${httpd_deploy_dir}/bahmni_config",
    path => "${os_path}",
    require => Exec["copy_implementation_config"]
  }

  exec { "set_permissions_of_bahmni_config" :
    provider => "shell",
    command => "chmod -R 775 ${httpd_deploy_dir}/bahmni_config",
    path => "${os_path}",
    require => Exec["copy_implementation_config"]
  }

}