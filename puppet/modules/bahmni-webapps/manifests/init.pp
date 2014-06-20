class bahmni-webapps {
  require openmrs
  require bahmni-configuration
  require bahmni-distro

  $openmrs_modules_dir = "/home/${bahmni_user}/.OpenMRS/modules"
  $serialization_omod_filename = "serialization.xstream-0.2.8-SNAPSHOT.omod"
  $ui_modules_dir = "${build_output_dir}/ui-modules"

  file { "${openmrs_modules_dir}" :
   owner  => "${bahmni_user}",
   group  =>  "${bahmni_user}",   
   mode   => 664,
   ensure    => directory
  }

  exec { "bahmni_omods" :
    command => "rm -rf ${openmrs_modules_dir}/* && cp ${build_output_dir}/${openmrs_distro_file_name_prefix}/*.omod ${openmrs_modules_dir} ${deployment_log_expression}",
    user    => "${bahmni_user}",
    require => [File["${openmrs_modules_dir}"], Exec["unzip_distro"]],
    path => "${os_path}"
  }

  exec { "serialization_omod_temporary_fix" :
    command => "cp ${package_dir}/${serialization_omod_filename} ${openmrs_modules_dir} ${deployment_log_expression}",
    user    => "${bahmni_user}",
    require => [Exec["bahmni_omods"]],
    path => "${os_path}"
  }

  exec { "explode_elis_atomfeed_jar" :
    command     => "unzip -o -d ${temp_dir}/${bahmni_elisatomfeedclient} ${openmrs_modules_dir}/${bahmni_elisatomfeedclient}.omod ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    require     => [Exec["bahmni_omods"]]
  }

  file { "${temp_dir}/run-modules-liquibase.sh" :
    ensure      => present,
    content     => template("bahmni-webapps/run-modules-liquibase.sh"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 554,
    require     => [Exec["explode_elis_atomfeed_jar"], Exec["serialization_omod_temporary_fix"]]
  }

  exec { "openmrs_modules_data" :
    command     => "${temp_dir}/run-modules-liquibase.sh ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    cwd         => "${tomcatInstallationDirectory}/webapps",
    require     => [Exec["bahmni_omods"], File["${temp_dir}/run-modules-liquibase.sh"]]
  }

}