class openelis {
  require ant

  $openelis_webapp_location =  "${tomcatInstallationDirectory}/webapps/openelis"
  $bahmni_openelis_temp_dir = "${temp_dir}/OpenElis"
  $log4j_xml_file = "${tomcatInstallationDirectory}/webapps/${openelis_war_file_name}/WEB-INF/classes/log4j.xml"

  file { "${openelis_webapp_location}" :
    ensure    => directory,
    recurse   => true,
    force     => true,
    purge     => true,
    owner => "${bahmni_user}",
    group => "${bahmni_user}",
  }

  exec { "latest_openelis_webapp" :
    command   => "unzip -o -q ${build_output_dir}/${openelis_war_file_name}.war -d ${openelis_webapp_location} ${deployment_log_expression}",
    provider  => shell,
    path      => "${os_path}",
    require   => [File["${deployment_log_file}"], File["${openelis_webapp_location}"]],
    user      => "${bahmni_user}",
  }

  exec { "bahmni_openelis_codebase" :
    provider => "shell",
    command => "git clone https://github.com/Bhamni/OpenElis.git ${bahmni_openelis_temp_dir} ${deployment_log_expression}",
    path => "${os_path}",
    creates   => "${bahmni_openelis_temp_dir}",
    timeout => 0
  }

  exec { "latest_bahmni_openelis_codebase" :
    provider => "shell",
    command => "git reset --hard && git clean -fd && git pull",
    path => "${os_path}",
    creates   => "${bahmni_openelis_temp_dir}",
    require => Exec["bahmni_openelis_codebase"]
  }

  exec { "openelis_setupdb" :
    provider => "shell",
    cwd => "${bahmni_openelis_temp_dir}",
    command => "ant setupDB",
    path => "${os_path}:${ant_home}/bin",
    require => Exec["latest_bahmni_openelis_codebase"]
  }  

  file { "${log4j_xml_file}" :
    ensure      => present,
    content     => template("openelis/log4j.xml.erb"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    require     => Exec["latest_openelis_webapp"],
    mode        => 664,
  }

}