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
  
  file { "${temp_dir}/run-liquibase.sh" :
    ensure      => present,
    content     => template("implementation-config/run-liquibase.sh"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 554
  }

  exec { "run_implementation_liquibase_migration" :
    command     => "${temp_dir}/run-liquibase.sh ${build_output_dir}/${openmrs_distro_file_name_prefix} ${build_output_dir}/$migrationsDirectory ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    cwd         => "${tomcatInstallationDirectory}/webapps",
    require     => [Exec["unzip_${implementationName}"],File["${temp_dir}/run-liquibase.sh"]]
  }

  exec { "copy_implementation_config" :
    command     => "cp -r ${build_output_dir}/$configDirectory ${httpd_deploy_dir}/bahmni-config",
    provider    => "shell",
    path        => "${os_path}",
    user       => "${bahmni_user}",
    group       => "${bahmni_user}",
    require     => Exec["unzip_${implementationName}"]
  }
}