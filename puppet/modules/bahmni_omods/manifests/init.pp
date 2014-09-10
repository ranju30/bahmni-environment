class bahmni_omods {
  require openmrs
  require bahmni-configuration
  require bahmni-distro

  $openmrs_modules_dir = "/home/${bahmni_user}/.OpenMRS/modules"
  $ui_modules_dir = "${build_output_dir}/ui-modules"
  $webapps_dir="${tomcatInstallationDirectory}/webapps"
  $liquibase_jar="${webapps_dir}/openmrs/WEB-INF/lib/liquibase-core-2.0.5.jar"
  $openmrs_war_path="${build_output_dir}/${openmrs_distro_file_name_prefix}/${openmrs_war_file_name}.war"

  file { "${openmrs_modules_dir}" :
   owner  => "${bahmni_user}",
   group  =>  "${bahmni_user}",   
   mode   => 664,
   ensure => directory
  }

  exec { "copy_core_bahmni_omods" :
    command => "rm -rf ${openmrs_modules_dir}/* && find ${build_output_dir}/${openmrs_distro_file_name_prefix} -type f -not -regex '.*atomfeed.*client.*\.omod' -exec cp '{}' '${openmrs_modules_dir}' ';' ${deployment_log_expression}",
    user    => "${bahmni_user}",
    require => File["${openmrs_modules_dir}"],
    path => "${os_path}"
  }

  file { "${temp_dir}/openmrs-liquibase-functions.sh" :
    ensure      => present,
    content     => template("bahmni_omods/openmrs-liquibase-functions.sh"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 554
  }

  file { "${temp_dir}/run-core-bahmni-modules-liquibase.sh" :
    ensure      => present,
    content     => template("bahmni_omods/run-core-bahmni-modules-liquibase.sh"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 554,
    require     => Exec["copy_core_bahmni_omods"]
  }

  exec { "run_core_bahmni_modules_liquibase" :
    command     => "${temp_dir}/run-core-bahmni-modules-liquibase.sh ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    require     => [File["${temp_dir}/run-core-bahmni-modules-liquibase.sh"], File["${temp_dir}/openmrs-liquibase-functions.sh"]]
  }

  if $deploy_bahmni_openelis == "true" {
    bahmni_omods::bahmni_atomfeed_client { "deploy_openelis_atomfeed_client":
      atomfeed_client_name => "openelis",
      require => Exec["run_core_bahmni_modules_liquibase"]
    }
  }  

  if $deploy_bahmni_openerp == "true" {
    bahmni_omods::bahmni_atomfeed_client { "deploy_openerp_atomfeed_client": 
      atomfeed_client_name => "openerp",
      require => Exec["run_core_bahmni_modules_liquibase"]
    }
  }
}