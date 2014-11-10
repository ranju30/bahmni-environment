class implementation_config::openmrs {
  $openmrs_dir = "/home/${bahmni_user}/.OpenMRS"
  $beanshell_dir = "${build_output_dir}/${implementation_name}_config/openmrs/beanshell"
  $obscalculator_dir = "${build_output_dir}/${implementation_name}_config/openmrs/obscalculator"
  $patient_matching_algorithm_dir = "${build_output_dir}/${implementation_name}_config/openmrs/patientMatchingAlgorithm"
  
  exec { "copyBeanshellToOpenMRSFolder" :
    command   => "cp -rf ${beanshell_dir} ${openmrs_dir}",
    provider  => shell,
    path      => "${os_path}",
    onlyif    => "test -d ${beanshell_dir}"
  }

  exec { "copyObsCalculatorToOpenMRSFolder" :
    command   => "cp -rf ${obscalculator_dir} ${openmrs_dir}",
    provider  => shell,
    path      => "${os_path}",
    onlyif    => "test -d ${obscalculator_dir}"
  }

  exec { "copyPatientMatchingAlgorithmToOpenMRSFolder" :
    command   => "cp -rf ${patient_matching_algorithm_dir} ${openmrs_dir}",
    provider  => shell,
    path      => "${os_path}",
    onlyif    => "test -d ${patient_matching_algorithm_dir}"
  }

  implementation_config::migrations { "implementation_config_migrations_openmrs":
    implementation_name => "${implementation_name}",
    app_name            => "openmrs"
  }

  exec { "copy_implementation_config" :
    command     => "rm -rf ${httpd_deploy_dir}/bahmni_config && unzip -q -o ${implementation_config::setup::implementation_zip_file} 'openmrs/apps/*' -d ${httpd_deploy_dir}/bahmni_config ${deployment_log_expression}",
    provider    => "shell",
    path        => "${os_path}"
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