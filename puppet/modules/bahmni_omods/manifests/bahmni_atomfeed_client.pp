define bahmni_omods::bahmni_atomfeed_client($atomfeed_client_name) {

    require bahmni_omods::config
  
	  $openmrs_modules_dir = "/home/${::config::bahmni_user}/.OpenMRS/modules"
    $atomfeed_client_omod_name = "${atomfeed_client_name}-atomfeed-client-${bahmni_release_version}"

    exec { "copy_${atomfeed_client_name}_atomfeed_omod" :
      command => "cp ${::config::build_output_dir}/${::config::openmrs_distro_file_name_prefix}/${atomfeed_client_omod_name}.omod ${openmrs_modules_dir}   ${::config::deployment_log_expression}",
      user    => "${::config::bahmni_user}",
      require => Exec["copy_core_bahmni_omods"],
      path => "${config::os_path}"
    }

    exec { "explode_${atomfeed_client_name}_atomfeed_jar" :
      command     => "unzip -o -d ${config::temp_dir}/${atomfeed_client_omod_name} ${openmrs_modules_dir}/${atomfeed_client_omod_name}.omod   ${::config::deployment_log_expression}",
      path        => "${config::os_path}",
      provider    => shell,
      require     => Exec["copy_${atomfeed_client_name}_atomfeed_omod"]
    }

    file { "${config::temp_dir}/run-${atomfeed_client_name}-atomfeed-client-liquibase.sh" :
      ensure      => present,
      content     => template("bahmni_omods/run-atomfeed-client-liquibase.sh"),
      owner       => "${::config::bahmni_user}",
      group       => "${::config::bahmni_user}",
      mode        => 554,
      require     => Exec["copy_${atomfeed_client_name}_atomfeed_omod"]
    }

    exec { "run_${atomfeed_client_name}_atomfeed_client_liquibase" :
      command     => "${config::temp_dir}/run-${atomfeed_client_name}-atomfeed-client-liquibase.sh   ${::config::deployment_log_expression}",
      path        => "${config::os_path}",
      provider    => shell,
      require     => [File["${config::temp_dir}/run-${atomfeed_client_name}-atomfeed-client-liquibase.sh"], File["${config::temp_dir}/openmrs-liquibase-functions.sh"], Exec["explode_${atomfeed_client_name}_atomfeed_jar"]]
    }
}