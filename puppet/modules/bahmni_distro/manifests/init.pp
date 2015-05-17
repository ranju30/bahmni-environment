class bahmni_distro inherits bahmni_distro::config {

  notice("Variable is ${::config::openmrs_distro_file_name_prefix}")

  file { "${::config::build_output_dir}/${::config::openmrs_distro_file_name_prefix}-distro.zip" :
    owner  => "${::config::bahmni_user}",
    group  =>  "${::config::bahmni_user}",   
    mode   => 777,
    ensure    => present
  }

  exec { "unzip_distro" :
    command   => "unzip -q -o ${::config::build_output_dir}/${::config::openmrs_distro_file_name_prefix}-distro.zip -d ${::config::build_output_dir} ${::config::deployment_log_expression}",
    provider  => shell,
    path      => "${config::os_path}",
    require   => [File["${::config::build_output_dir}/${::config::openmrs_distro_file_name_prefix}-distro.zip"]]
  }

  exec { "change_distro_permissions" :
    command   => "chmod -R 777 ${::config::build_output_dir}/${::config::openmrs_distro_file_name_prefix}",
    provider  => shell,
    path      => "${config::os_path}",
    require   => [Exec["unzip_distro"]]
  }
}