class openmrs {
  $bahmnicore_properties = "/home/${bahmni_user}/.OpenMRS/bahmnicore.properties"
  $log4j_xml_file = "${tomcatInstallationDirectory}/webapps/openmrs/WEB-INF/classes/log4j.xml"
  $web_xml_file = "$tomcatInstallationDirectory/webapps/openmrs/WEB-INF/web.xml"
  $log_file = "${logs_dir}/openmrs-module.log"
  $log_expression = ">> ${log_file} 2>> ${logs_file}"

  file { "$log_file}" :
    ensure        => absent,
    purge         => true
  }

  exec {"install-openmrs" :
    command     => "cp ${package_dir}/openmrs.war ${tomcatInstallationDirectory}/webapps",
    user        => "${bahmni_user}",
    path        => "${os_path}"
  }

  file { "${imagesDirectory}" :
    ensure      => directory,
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  file { "$tomcatInstallationDirectory/webapps/patient_images" :
    ensure => "link",
    target => "${imagesDirectory}"
  }

  file { "/home/${bahmni_user}/.OpenMRS" :
    ensure      => directory,
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  file { "${bahmnicore_properties}" :
    ensure      => present,
    content     => template("openmrs/bahmnicore.properties.erb"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  exec { "unjar openmrs" :
    command   => "unzip -o -q ${package_dir}/openmrs.war -d ${tomcatInstallationDirectory}/webapps/openmrs",
    provider  => "shell",
    path      => "${os_path}"
  }

  file { "${log4j_xml_file}" :
    ensure      => present,
    content     => template("openmrs/log4j.xml.erb"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  file { "${web_xml_file}" :
    ensure      => present,
    content     => template("openmrs/web.xml"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  file { "${temp_dir}/create-openmrs-db.sql" :
    ensure      => present,
    content     => template("openmrs/database.sql"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  exec { "create openmrs database" :
    command     => "mysql -uroot -p${mysqlRootPassword} < ${temp_dir}/create-openmrs-db.sql ${log_expression}",
    path        => "${os_path}",
    provider    => "shell"
  }

  file { "${temp_dir}/run-liquibase.sh" :
    ensure      => present,
    content     => template("openmrs/run-liquibase.sh"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  exec { "setup base data" :
    command     => "${temp_dir}/run-liquibase.sh ${log_expression}",
    path        => "${os_path}",
    provider    => "shell"
  }
}