class bahmni-webapps {
  require openmrs
  require bahmni-configuration
  require bahmni-distro
  require bahmni-data

  $openmrs_dir = "/home/${bahmni_user}/.OpenMRS"
  $openmrs_modules_dir = "/home/${bahmni_user}/.OpenMRS/modules"
  $ui_modules_dir = "${build_output_dir}/ui-modules"

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
    command => "cp ${build_output_dir}/${openmrs_distro_file_name_prefix}/*.omod ${openmrs_modules_dir} ${deployment_log_expression}",
    user    => "${bahmni_user}",
    require => [File["${openmrs_modules_dir}"], Exec["unzip_distro"]],
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
    require     => [Exec["explode_elis_atomfeed_jar"]]
  }

  exec { "openmrs_modules_data" :
    command     => "${temp_dir}/run-modules-liquibase.sh ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    cwd         => "${tomcatInstallationDirectory}/webapps",
    require     => [Exec["bahmni_omods"], File["${temp_dir}/run-modules-liquibase.sh"]]
  }

  file { "${build_output_dir}/elisatomfeedclient-omod-beanshell.zip" :
       ensure      => present,
       owner       => "${bahmni_user}",
       group       => "${bahmni_user}",
       mode        => 777
  }

  exec { "openelis-atomfeed-beanshell" :
     command => "unzip -o ${build_output_dir}/elisatomfeedclient-omod-beanshell.zip -d $openmrs_dir/beanshell",
     path        => "${os_path}",
     provider    => shell
   }
}