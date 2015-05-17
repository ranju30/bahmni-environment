class openelis inherits openelis::config {
  require tomcat::clean
  include bahmni_revisions
  include bahmni_configuration
  
  $openelis_webapp_location =  "${::config::webapps_dir}/openelis"
  $bahmni_openelis_temp_dir = "${temp_dir}/OpenElis"
  $log4j_xml_file = "${::config::webapps_dir}/${openelis_war_file_name}/WEB-INF/classes/log4j.xml"
  
  
  file { "${openelis_webapp_location}" : ensure => absent, purge => true}

  exec { "latest_openelis_webapp" :
    command   => "unzip -o -q ${::config::build_output_dir}/${openelis_war_file_name}.war -d ${openelis_webapp_location}   ${::config::deployment_log_expression}",
    provider  => shell,
    path      => "${config::os_path}",
    require   => [File["${deployment_log_file}"], File["${openelis_webapp_location}"]],
    user      => "${::config::bahmni_user}",
  }

  file { "${bahmni_openelis_temp_dir}" : ensure => absent, purge => true}

  exec { "bahmni_openelis_codebase" :
    provider => "shell",
    command   => "unzip -o -q ${::config::build_output_dir}/OpenElis.zip -d ${temp_dir}   ${::config::deployment_log_expression}",
    path => "${config::os_path}",
    require   => [File["${bahmni_openelis_temp_dir}"]]
  }

  file { "${log4j_xml_file}" :
    ensure      => present,
    content     => template("openelis/log4j.xml.erb"),
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
    require     => Exec["latest_openelis_webapp"],
    mode        => 664,
  }

  file { "${uploadedFilesDirectory}/elis" :
    ensure => directory,
    mode => 774,
    owner => "${::config::bahmni_user}",
    group => "${::config::bahmni_user}",
    require => File["${uploadedFilesDirectory}"],
  }

  if $is_passive_setup == "false" {
    include openelis::database
  }
}

class openelis::database {
    $bahmni_openelis_temp_dir = "${temp_dir}/OpenElis"

    exec { "openelis_setupdb" :
    provider => "shell",
    cwd => "${bahmni_openelis_temp_dir}",
    command => "ant setupDB ${::config::deployment_log_expression}",
    path => "${config::os_path}:${::config::ant_home}/bin",
    require => Exec["bahmni_openelis_codebase"]
  }
}
