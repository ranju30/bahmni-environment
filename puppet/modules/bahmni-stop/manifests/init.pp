class bahmni-stop {
  exec { "catalina_stop" :
    command     => "sh ${tomcatInstallationDirectory}/bin/catalina.sh stop ${deployment_log_expression}",
    user        => "${bahmni_user}",
    provider    => shell,
    path        => "${os_path}"
  }
}