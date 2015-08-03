class oviyam2{
  require yum_repo

  $oviyam2_webapp_location =  "${tomcatInstallationDirectory}/webapps/oviyam2"
  $oviyam2_war_filename = "oviyam2"
  $classpath = "CLASSPATH=\"/home/${bahmni_user}/apache-tomcat-8.0.12/webapps/oviyam2/WEB-INF/lib/*\""

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
      require   => [Class["tomcat"], File["copy_oviyam2"]],
      user      => "${bahmni_user}",
    }

    exec { "set_env" :
      command   => "grep -q -F \"${classpath}\" ${tomcatInstallationDirectory}/bin/setenv.sh || echo \"${classpath}\" >> ${tomcatInstallationDirectory}/bin/setenv.sh",
      provider  => shell,
      path      => "${os_path}",
      require   => File["copy_oviyam2"],
      user      => "${bahmni_user}",
    }
  }
}