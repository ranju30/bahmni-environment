class openmrs inherits openmrs::config {
  require bahmni_distro
  require tomcat::clean
  require bahmni_snapshot_migrations

  $log4j_xml_file = "${::config::webapps_dir}/openmrs/WEB-INF/classes/log4j.xml"
  $openmrs_webapp_location =  "${::config::webapps_dir}/openmrs"
  $web_xml_file = "${openmrs_webapp_location}/WEB-INF/web.xml"

  exec { "delete_${openmrs_webapp_location}" :
    command     => "rm -rf ${openmrs_webapp_location}",
    path        => "${config::os_path}",
  }

  file { "/home/${::config::bahmni_user}/.OpenMRS/openmrs-runtime.properties" :
    ensure      => present,
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
    mode        => 664,
    content     => template("openmrs/openmrs-runtime.properties"),
    require     => File["/home/${::config::bahmni_user}/.OpenMRS"]
  }

  exec { "latest_openmrs_webapp" :
    command   => "unzip -o -q ${::config::build_output_dir}/${openmrs_distro_file_name_prefix}/${openmrs_war_file_name}.war -d ${openmrs_webapp_location}   ${::config::deployment_log_expression}",
    provider  => shell,
    path      => "${config::os_path}",
    require   => [File["${::config::deployment_log_file}"], Exec["delete_${openmrs_webapp_location}"]],
    user      => "${::config::bahmni_user}"
  }

  file { "/home/${::config::bahmni_user}/.OpenMRS" :
    ensure      => directory,
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
    mode        => 666
  }

  file { "${log4j_xml_file}" :
    ensure      => present,
    content     => template("openmrs/log4j.xml.erb"),
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
    require     => Exec["latest_openmrs_webapp"],
    mode        => 664,
  }

  file { "${web_xml_file}" :
    ensure      => present,
    content     => template("openmrs/web.xml"),
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
    require     => Exec["latest_openmrs_webapp"],
    mode        => 664
  }

  file { "${temp_dir}/openmrs-predeploy.sql" :
    ensure      => present,
    content     => template("openmrs/predeploy.sql"),
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}"
  }

  exec { "openmrs_predeploy" :
    command     => "mysql -h${db_server} -uroot -p${mysqlRootPassword} < ${temp_dir}/openmrs-predeploy.sql   ${::config::deployment_log_expression}",
    path        => "${config::os_path}",
    provider    => shell,
    require     => [Exec["openmrs_database"],File["${temp_dir}/openmrs-predeploy.sql"]]
  }

  file { "${temp_dir}/run-liquibase-openmrs.sh" :
    ensure      => present,
    content     => template("openmrs/run-liquibase.sh"),
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
    mode        => 554,
    require     => [Class['bahmni_snapshot_migrations'], Exec['run-snapshot-migrations']]
 }

  exec { "openmrs_data" :
    command     => "${temp_dir}/run-liquibase-openmrs.sh    ${::config::deployment_log_expression}",
    path        => "${config::os_path}",
    provider    => shell,
    timeout     => 0,
    cwd         => "${::config::webapps_dir}",
    require     => [Exec["openmrs_predeploy"], File["${temp_dir}/run-liquibase-openmrs.sh"], Exec["latest_openmrs_webapp"]]
  }

   exec { "bahmni_java_utils_jars" :
    command => "cp ${::config::build_output_dir}/${::config::openmrs_distro_file_name_prefix}/mail-appender-${::config::bahmni_release_version}.jar ${::config::webapps_dir}/openmrs/WEB-INF/lib ${::config::deployment_log_expression}",
    user    => "${::config::bahmni_user}",
    require => Exec["latest_openmrs_webapp"],
    path => "${config::os_path}"
  }

}