class oviyam2{
  require yum_repo

  $oviyam2_webapp_location =  "${tomcatInstallationDirectory}/webapps/oviyam2"
  $oviyam2_war_filename = "oviyam2"

  file { "${oviyam2_webapp_location}" : ensure => absent, purge => true}

  if ($bahmni_pacs_required == "true") {
    exec { "latest_oviyam2_webapp" :
      command   => "rm -rf ${oviyam2_webapp_location} && unzip -o -q ${build_output_dir}/${oviyam2_war_filename}.war -d ${oviyam2_webapp_location} ${deployment_log_expression}",
      provider  => shell,
      path      => "${os_path}",
      require   => [File["${deployment_log_file}"], File["${oviyam2_webapp_location}"]],
      user      => "${bahmni_user}",
    }

    file { "CLASSPATH" :
      path    => "${tomcatInstallationDirectory}/bin/setenv.sh",
      ensure  => present,
      content => template ("oviyam2/setenv.sh"),
      owner   => "${bahmni_user}",
      mode    => 664,
    }

  }
}