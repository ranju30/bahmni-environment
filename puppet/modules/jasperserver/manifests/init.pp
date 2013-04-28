class jasperserver {
  file { "${jasperHome}" :
    ensure      => directory,
    purge       => true,
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  exec { "unzip_jasperserver" :
    command     => "unzip -o -q /packages/jasperreports-server-cp-5.0.0-bin.zip -d ${jasperHome}/..",
    provider    => "shell",
    path        => "$os_path"
  }

  exec {"copy_mysql_jar" :
    command      => "cp /usr/share/java/mysql-connector-java.jar ${jasperHome}/buildomatic/conf_source/db/mysql/jdbc",
    path         => "$os_path"
  }

  exec{ "change_jasperserver_owner" :
    command     => "chown -R ${bahmni_user}:${bahmni_user} ${jasperHome}",
    path        => "$os_path"
  }

  file { "java_home_path" :
    path        => "/etc/profile.d/java.sh",
    ensure      => "present",
    content     => template ("jasperserver/java.sh"),
    mode        => '644',
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
    path        => "$os_path"
  }

  exec { "make_jasperserver" :
    command     => "echo '$jasperResetDb' | /bin/sh js-install-ce.sh minimal",
    cwd         => "${jasperHome}/buildomatic",
    user        => "${bahmni_user}",
    path        => "$os_path"
  }

  file { "${temp_dir}/configure_jasper_home.sh" :
     content    => template("jasperserver/configure_jasper_home.sh"),
     owner      => "${bahmni_user}",
     group      => "${bahmni_user}",
     mode       =>  764
  }

  exec { "config-jasper-home" :
    command     => "sh ${temp_dir}/configure_jasper_home.sh ${jasperHome} ${bahmni_user}",
    user        => "${bahmni_user}",
    path        => "$os_path"
  }
}