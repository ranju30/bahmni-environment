class implementation-config($implementationName) {

  $implementationZipFile = "${build_output_dir}/${implementationName}_config.zip"
  $migrationsDirectory = "${implementationName}_config/migrations"
  $configDirectory = "${implementationName}_config/openmrs"
  $openmrs_dir = "/home/${bahmni_user}/.OpenMRS"

  file { "${implementationZipFile}" :
    ensure    => present
  }

  exec { "unzip_${implementationName}" :
    command   => "rm -rf ${build_output_dir}/${implementationName}_config && unzip -q -o $implementationZipFile -d ${build_output_dir}/${implementationName}_config ${deployment_log_expression}",
    provider  => shell,
    path      => "${os_path}",
    require   => [File["${implementationZipFile}"]]
  }

  exec { "copyLogoToOpenelis" :
    command   => "cp ${build_output_dir}/${implementationName}_config/openelis/images/labLogo.jpg ${tomcatInstallationDirectory}/webapps/${openelis_war_file_name}/WEB-INF/reports/images",
    provider  => shell,
    path      => "${os_path}",
    require   => Exec["unzip_${implementationName}"],
    onlyif    => "test -f ${build_output_dir}/${implementationName}_config/openelis/images/labLogo.jpg"
  }

  exec { "copyLogoToOpenelisForReportConfig" :
    command   => "cp ${build_output_dir}/${implementationName}_config/openelis/images/labLogo.jpg ${tomcatInstallationDirectory}/webapps/${openelis_war_file_name}/images",
    provider  => shell,
    path      => "${os_path}",
    require   => Exec["unzip_${implementationName}"],
    onlyif    => "test -f ${build_output_dir}/${implementationName}_config/openelis/images/labLogo.jpg"
  }
  
  exec { "copyBeanshellToOpenMRSFolder" :
    command   => "cp -rf ${build_output_dir}/${implementationName}_config/openmrs/beanshell ${openmrs_dir}",
    provider  => shell,
    path      => "${os_path}",
    require   => Exec["unzip_${implementationName}"]
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

  exec { "bahmni_openelis_codebase_for_liquibase_jar" :
    provider => "shell",
    command  => "rm -rf ${bahmni_openelis_temp_dir} && unzip -o -q ${build_output_dir}/OpenElis.zip -d ${temp_dir} ${deployment_log_expression}",
    path     => "${os_path}",
    onlyif    => "test -f ${build_output_dir}/${implementationName}_config/migrations/openelis/liquibase.xml"
  }

  file { "${temp_dir}/run-implementation-openelis-config-liquibase.sh" :
    ensure      => present,
    content     => template("implementation-config/run-implementation-openelis-config-liquibase.sh"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 554
  }

  exec { "run_implementation_openelis_config_liquibase_migration" :
    command     => "${temp_dir}/run-implementation-openelis-config-liquibase.sh  ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    cwd         => "${build_output_dir}/${migrationsDirectory}",
    require     => [Exec["unzip_${implementationName}"],File["${temp_dir}/run-implementation-openelis-config-liquibase.sh"],Exec["bahmni_openelis_codebase_for_liquibase_jar"]],
    onlyif    => "test -f ${build_output_dir}/${implementationName}_config/migrations/openelis/liquibase.xml"
  }

  exec { "copy_implementation_config" :
    command     => "rm -rf ${httpd_deploy_dir}/bahmni_config && unzip -q -o $implementationZipFile openmrs/* -d ${httpd_deploy_dir}/bahmni_config ${deployment_log_expression}",
    provider    => "shell",
    path        => "${os_path}",
    require     => [Exec["unzip_${implementationName}"]]
  }

  exec { "set_owner_of_bahmni_config" :
    provider => "shell",
    command => "chown -R ${bahmni_user}:${bahmni_user} ${httpd_deploy_dir}/bahmni_config",
    path => "${os_path}",
    require => Exec["copy_implementation_config"]
  }

  exec { "set_permissions_of_bahmni_config" :
    provider => "shell",
    command => "chmod -R  777 ${httpd_deploy_dir}/bahmni_config",
    path => "${os_path}",
    require => Exec["copy_implementation_config"]
  }

}