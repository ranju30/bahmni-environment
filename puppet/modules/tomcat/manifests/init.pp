class tomcat {
  exec { "tomcat_untar" :
    command   => "tar --overwrite -zxf ${package_dir}/apache-tomcat-${tomcat_version}.tar.gz -C ${tomcatParentDirectory}",
    user      => "${bahmni_user}",
    creates   => "${tomcatInstallationDirectory}",
    provider  => "shell"
  }

  file { "${tomcatInstallationDirectory}/bin/setenv.sh" :
    ensure    => present,
    content   => template("tomcat/setenv.sh"),
    mode      => 777,
    group     => "${bahmni_user}",
    owner     => "${bahmni_user}",
  }

  file { "/etc/init.d/tomcat" :
    ensure    => present,
    content   => template("tomcat/tomcat.initd"),
    mode      => 777,
    group     => "root",
    owner     => "root",
  }

  file { "${tomcatInstallationDirectory}/conf/server.xml" :
    ensure    => present,
    content   => template("tomcat/server.xml.erb"),
    group     => "${bahmni_user}",
    owner     => "${bahmni_user}",
    replace   => true,
  }

  file { "${tomcatInstallationDirectory}/conf/tomcat-users.xml" :
    ensure    => present,
    content   => template("tomcat/tomcat-users.xml.erb"),
    group     => "${bahmni_user}",
    owner     => "${bahmni_user}",
  }

  exec{ "change_tomcat_owner" :
    command   => "chown -R ${bahmni_user}:${bahmni_user} ${tomcatInstallationDirectory}",
    path      => "${os_path}"
  }

  exec { "installtomcatservice" :
    provider  => "shell",
    user      => "root",
    command   => "chkconfig --add tomcat",
    require   => Exec["change_tomcat_owner"],
    onlyif    => "chkconfig --list tomcat; [ $? -eq 1 ]"
  }

  service { "tomcat" :
    ensure    => running,
    enable    => true,
    hasstatus => false,
    path      => "${os_path}"
  }
}