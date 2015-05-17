class bahmni_omods inherits bahmni_omods::config {
  
  require openmrs
  require bahmni_configuration
  require bahmni_distro


  file { "${openmrs_modules_dir}" :
   owner  => "${::config::bahmni_user}",
   group  =>  "${::config::bahmni_user}",   
   mode   => 664,
   ensure => directory
  }

  exec { "copy_core_bahmni_omods" :
    command => "rm -rf ${openmrs_modules_dir}/* && find ${::config::build_output_dir}/${::config::openmrs_distro_file_name_prefix} -type f -not -regex '.*atomfeed.*client.*\.omod' | grep .omod | xargs -I file cp file ${openmrs_modules_dir}   ${::config::deployment_log_expression}",
    user    => "${::config::bahmni_user}",
    require => File["${openmrs_modules_dir}"],
    path => "${config::os_path}"
  }

  file { "${config::temp_dir}/openmrs-liquibase-functions.sh" :
    ensure      => present,
    content     => template("bahmni_omods/openmrs-liquibase-functions.sh"),
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
    mode        => 554
  }

  file { "${config::temp_dir}/run-core-bahmni-modules-liquibase.sh" :
    ensure      => present,
    content     => template("bahmni_omods/run-core-bahmni-modules-liquibase.sh"),
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
    mode        => 554,
    require     => Exec["copy_core_bahmni_omods"]
  }

  exec { "run_core_bahmni_modules_liquibase" :
    command     => "${config::temp_dir}/run-core-bahmni-modules-liquibase.sh   ${::config::deployment_log_expression}",
    path        => "${config::os_path}",
    provider    => shell,
    require     => [File["${config::temp_dir}/run-core-bahmni-modules-liquibase.sh"], File["${config::temp_dir}/openmrs-liquibase-functions.sh"]]
  }

  if "${::config::bahmni_openelis_required}" == "true" {
    bahmni_omods::bahmni_atomfeed_client { "deploy_openelis_atomfeed_client":
      atomfeed_client_name => "openelis",
      require => Exec["run_core_bahmni_modules_liquibase"]
    }
  }  

  if "${::config::bahmni_openerp_required}" == "true" {
    bahmni_omods::bahmni_atomfeed_client { "deploy_openerp_atomfeed_client": 
      atomfeed_client_name => "openerp",
      require => Exec["run_core_bahmni_modules_liquibase"]
    }
  }
}