class predeploy {

  file { "${temp_dir}/openmrs-predeploy.sql" :
    ensure      => present,
    content     => template("predeploy/predeploy.sql"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  exec { "openmrs_predeploy" :
    command     => "mysql -uroot -p${mysqlRootPassword} < ${temp_dir}/openmrs-predeploy.sql ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    require     => File["${temp_dir}/openmrs-predeploy.sql"]
  }

}