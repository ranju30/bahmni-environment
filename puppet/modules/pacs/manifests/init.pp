class pacs {
  require tomcat::clean
  include bahmni_revisions
  include bahmni_configuration

  $pacs_webapp_location =  "${tomcatInstallationDirectory}/webapps/pacs"
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

  file { "${bahmni_pacs_temp_dir}" : ensure => absent, purge => true}

  exec { "bahmni_pacs_codebase" :
    provider => "shell",
    command   => "unzip -o -q ${build_output_dir}/pacs-integration.zip -d ${temp_dir} ${deployment_log_expression}",
    path => "${os_path}",
    require   => [File["${bahmni_pacs_temp_dir}"]]
  }

  file { "${log4j_xml_file}" :
    ensure      => present,
    content     => template("pacs/log4j.xml.erb"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    require     => Exec["latest_pacs_webapp"],
    mode        => 664,
  }

  if $is_passive_setup == "false" {
    include pacs::database
  }
}

class pacs::database {
  $bahmni_pacs_temp_dir = "${temp_dir}/PACS"

  file { "${bahmni_pacs_temp_dir}/scripts/initDB.sh":
    ensure => present,
    mode   => 755,
    require => [Exec["bahmni_pacs_codebase"]]
  }

  exec { "pacs_initdb" :
    provider    => "shell",
    cwd         => "${bahmni_pacs_temp_dir}",
    command     => "scripts/initDB.sh",
    require     => [File["${bahmni_pacs_temp_dir}/scripts/initDB.sh"]]
  }

}
