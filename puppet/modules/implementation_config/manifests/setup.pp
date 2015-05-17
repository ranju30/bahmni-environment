class implementation_config::setup inherits implementation_config::config {
  
  $implementation_zip_file = "${::config::build_output_dir}/${implementation_name}_config.zip"

 file { "${::config::build_output_dir}/${implementation_name}_config" : ensure => absent, purge => true}

  exec { "unzip_${implementation_name}" :
    command   => "rm -rf ${::config::build_output_dir}/${implementation_name}_config && unzip -q -o $implementation_zip_file -d ${::config::build_output_dir}/${implementation_name}_config   ${::config::deployment_log_expression}",
    provider  => shell,
    path      => "${config::os_path}",
    require   => [File["${::config::build_output_dir}/${implementation_name}_config"]]
  }
}