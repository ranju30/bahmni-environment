class bahmni_pacs {
  if ($bahmni_pacs_required == "true") {
    require tomcat::clean

    $tomcat_webapp_location = "${tomcatInstallationDirectory}/webapps"
    $pacs_webapp_location =  "${$tomcat_webapp_location}/pacs-integration"

    $bahmni_pacs_temp_dir = "${temp_dir}/PACS"
    $log4j_xml_file = "${tomcatInstallationDirectory}/webapps/${$pacs_war_file_name}/WEB-INF/classes/log4j.xml"

    exec { "clear_bahmni_pacs_webapp" :
      command   => "rm -rf ${tomcatInstallationDirectory}/webapps/${pacs_war_file_name}",
      provider  => shell,
      path      => "${os_path}",
      user      => "${bahmni_user}"
    }

    exec { "latest_pacs_webapp" :
      command   => "unzip -o -q ${build_output_dir}/${pacs_war_file_name}.war -d ${tomcat_webapp_location}/${pacs_war_file_name} ${deployment_log_expression}",
      provider  => shell,
      path      => "${os_path}",
      require   => [Exec["clear_bahmni_pacs_webapp"]],
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
  } else {
    notice ("Not installing PACS Module. ")
  }
}