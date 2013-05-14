class openmrs-setup {
  require tomcat

  exec { "openmrs_webapp" :
    command   => "unzip -o -q ${build_output_dir}/openmrs.war -d ${tomcatInstallationDirectory}/webapps/openmrs",
    provider  => shell,
    path      => "${os_path}"
  }

  # exec { "catalina_start" :
  #   command     => "sh ${tomcatInstallationDirectory}/bin/catalina.sh start ${deployment_log_expression}",
  #   user        => "${bahmni_user}",
  #   provider    => shell,
  #   path        => "${os_path}"
  # }

  file { "${temp_dir}/create-openmrs-db.sql" :
    ensure      => present,
    content     => template("openmrs/database.sql"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  exec { "openmrs_database" :
    command     => "mysql -uroot -p${mysqlRootPassword} < ${temp_dir}/create-openmrs-db.sql ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    require     => File["${temp_dir}/create-openmrs-db.sql"]
  }

  file { "${temp_dir}/run-liquibase.sh" :
    ensure      => present,
    content     => template("openmrs/run-liquibase.sh"),
    owner       => "${bahmni_user}",
    mode        => 544
  }

  exec { "openmrs_data" :
    command     => "${temp_dir}/run-liquibase.sh ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => "shell",
    cwd         => "${tomcatInstallationDirectory}/webapps",
    require     => [Exec["openmrs_database"], File["${temp_dir}/run-liquibase.sh"], Exec["openmrs_webapp"]]
  }
}