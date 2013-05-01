class jasperserver {
  $log_file = "${logs_dir}/jasperserver-module.log"
  $log_expression = ">> ${log_file} 2>> ${log_file}"

  file { "$log_file}" :
    ensure        => absent,
    purge         => true
  }

  file { "${jasperHome}" :
      ensure      => directory,
      purge       => true,
      recurse     => true,
      owner       => "${bahmni_user}",
      group       => "${bahmni_user}"
    }

  exec { "unzip_jasperserver" :
    command     => "unzip -o -q ${package_dir}/jasperreports-server-cp-5.0.0-bin.zip -d ${jasperHome}/.. ${log_expression}",
    provider    => "shell",
    path        => "${os_path}"
  }

  exec {"copy_mysql_jar" :
    command     => "cp /usr/share/java/mysql-connector-java.jar ${jasperHome}/buildomatic/conf_source/db/mysql/jdbc",
    path        => "${os_path}"
  }

  exec { "change_jasperserver_owner" :
    command     => "chown -R ${bahmni_user}:${bahmni_user} ${jasperHome}",
    path        => "${os_path}"
  }

  file { "${jasperHome}/buildomatic/default_master.properties" :
    content     => template("jasperserver/default_master.properties.erb"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  file { "${jasperHome}/buildomatic/bin/do-js-setup.sh" :
      content     => template("jasperserver/do-js-setup.sh"),
      owner       => "${bahmni_user}",
      group       => "${bahmni_user}"
  }

  exec { "set_jasperserver_scripts_permission" :
      command     => "find . -name '*.sh' | xargs chmod u+x",
      user        => "${bahmni_user}",
      cwd         => "${jasperHome}",
      path        => "${os_path}"
  }

  exec { "set_jasperserver_ant_permission" :
      command     => "chmod u+x ${jasperHome}/apache-ant/bin/ant",
      user        => "${bahmni_user}",
      cwd         => "${jasperHome}",
      path        => "${os_path}"
  }

  exec { "make_jasperserver" :
    command      => "echo y | sh js-install-ce.sh minimal > ${logs_dir}/jasper-install.log ${log_expression}",
    cwd         => "${jasperHome}/buildomatic",
    user        => "${bahmni_user}",
    path        => "${os_path}"
  }

  file { "${temp_dir}/configure_jasper_home.sh" :
    content    => template("jasperserver/configure_jasper_home.sh"),
    owner      => "${bahmni_user}",
    group      => "${bahmni_user}",
    mode       => 764
  }

  exec { "config-jasper-home" :
    command     => "sh ${temp_dir}/configure_jasper_home.sh ${jasperHome} ${bahmni_user} > ${logs_dir}/logs/configure-jasper-home.log 2>&1",
    user        => "${bahmni_user}",
    path        => "${os_path}"
  }
}