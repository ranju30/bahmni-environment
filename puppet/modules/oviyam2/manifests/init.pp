class oviyam2{
  require yum_repo

  $oviyam2_webapp_location =  "${tomcatInstallationDirectory}/webapps/oviyam2"
  $oviyam2_war_filename = "oviyam2"

  if ($bahmni_pacs_required == "true") {
    file { "copy_oviyam2" :
      path    => "${temp_dir}/oviyam2.sh",
      ensure  => present,
      content => template ("oviyam2/oviyam2.sh"),
      owner   => "${bahmni_user}",
      mode    => 664,
    }

    exec { "exec_oviyam2" :
      command   => "sh ${temp_dir}/oviyam2.sh ${deployment_log_expression}",
      provider  => shell,
      path      => "${os_path}",
      require   => File["copy_oviyam2"],
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