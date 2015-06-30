class pacs {
  require tomcat::clean

  $pacs_webapp_location =  "${tomcatInstallationDirectory}/webapps/pacs-integration"
  $bahmni_pacs_temp_dir = "${temp_dir}/PACS"
  $log4j_xml_file = "${tomcatInstallationDirectory}/webapps/${$pacs_war_file_name}/WEB-INF/classes/log4j.xml"

  file { "${pacs_webapp_location}" : ensure => absent, purge => true}

  exec { "latest_pacs_webapp" :
    command   => "rm -rf ${pacs_webapp_location} && unzip -o -q ${build_output_dir}/${$pacs_war_file_name}.war -d ${pacs_webapp_location} ${deployment_log_expression}",
    provider  => shell,
    path      => "${os_path}",
    require   => [File["${deployment_log_file}"], File["${pacs_webapp_location}"]],
    user      => "${bahmni_user}",
  }

  file { "${log4j_xml_file}" :
    ensure      => present,
    content     => template("pacs/log4j.xml.erb"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    require     => Exec["latest_pacs_webapp"],
    mode        => 664,
  }
}

class pacs::database {
  $bahmni_pacs_temp_dir = "${temp_dir}/PACS"

  file { "${temp_dir}/create-pacs-db-and-user.sql" :
    ensure      => present,
    content     => template("bahmni_snapshot_migrations/database.sql"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  exec { "pacs_database" :
    command     => "psql -Upostgres < ${temp_dir}/create-pacs-db-and-user.sql ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    require     => File["${temp_dir}/create-pacs-db-and-user.sql"]
  }
}
