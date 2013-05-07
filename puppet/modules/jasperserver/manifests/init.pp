class jasperserver {
  require tomcat
  
  $log_file = "${logs_dir}/jasperserver-module.log"
  $log_expression = ">> ${log_file} 2>> ${log_file}"
  $default_master_properties = "${jasperHome}/buildomatic/default_master.properties"
  $do_js_setup_script = "${jasperHome}/buildomatic/bin/do-js-setup.sh"

  file { "${log_file}" :
    ensure        => absent,
    purge         => true
  }

  file { "${jasperHome}" :
    mode        => 744,
    ensure      => directory,
    owner       => "${bahmni_user}",
    loglevel    => "warning",
    recurse     => true
  }

  exec { "extracted_jasperserver" :
    command     => "unzip -q -n ${packages_servers_dir}/jasperreports-server-cp-5.0.0-bin.zip -d ${jasperHome}/.. ${log_expression}",
    provider    => shell,
    user        => "${bahmni_user}",
    path        => "${os_path}",
    require     => [File["${jasperHome}"], File["${log_file}"]],
    loglevel    => "warning"
  }

  # exec { "jasperserver_scripts_permission" :
  #   command     => "find . -name '*.sh' | xargs chmod u+x ${log_expression}",
  #   user        => "${jssUser}",
  #   require     => [Exec["extracted_jasperserver"], File["${do_js_setup_script}"]],
  #   cwd         => "${jasperHome}",
  #   path        => "${os_path}"
  # } 

  exec {"jasper_mysql_connector" :
    command      => "cp ${packages_servers_dir}/mysql-connector-java-${mysql_connector_java_version}.jar ${jasperHome}/buildomatic/conf_source/db/mysql/jdbc",
    path        => "${os_path}",
    user        => "${bahmni_user}",
    require     => Exec["extracted_jasperserver"]
  }

  file { "${default_master_properties}" :
    content     => template("jasperserver/default_master.properties.erb"),
    owner       => "${bahmni_user}",
    mode        => 544,
    require     => Exec["extracted_jasperserver"]
  }

  file { "${do_js_setup_script}" :
    content     => template("jasperserver/do-js-setup.sh"),
    mode        => 544,
    owner       => "${bahmni_user}",
    require     => Exec["extracted_jasperserver"]
  }

  exec { "make_jasperserver" :
    command     => "echo y | sh js-install-ce.sh minimal > ${logs_dir}/jasper-install.log &2>1",
    cwd         => "${jasperHome}/buildomatic",
    user        => "${bahmni_user}",
    path        => "${os_path}",
    provider    => "shell",
    require     => [Exec["extracted_jasperserver"], File["${do_js_setup_script}"], File["${default_master_properties}"], Exec["jasper_mysql_connector"]]
  }

  file { "${temp_dir}/configure_jasper_home.sh" :
    content    => template("jasperserver/configure_jasper_home.sh"),
    owner      => "${bahmni_user}",
    mode       => 544
  }

  exec { "config_jasper_home" :
    command     => "sh ${temp_dir}/configure_jasper_home.sh ${jasperHome} ${bahmni_user} > ${logs_dir}/configure-jasper-home.log 2>&1",
    user        => "${bahmni_user}",
    path        => "${os_path}",
    require     => File["${temp_dir}/configure_jasper_home.sh"],
    provider    => shell
  }
}