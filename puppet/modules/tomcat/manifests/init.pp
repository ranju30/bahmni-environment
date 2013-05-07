class tomcat {
  require java

  exec { "tomcat_untar" :
    command   => "tar -zxf --keep-newer-files ${packages_servers_dir}/apache-tomcat-${tomcat_version}.tar.gz -C ${tomcatParentDirectory}",
    user      => "${bahmni_user}",
    creates   => "${tomcatInstallationDirectory}",
    provider  => shell
  }

  file { "CATALINA_OPTS" :
    path    => "${tomcatInstallationDirectory}/bin/setenv.sh",
    ensure  => present,
    content => template ("tomcat/setenv.sh"),
    user    => "${bahmni_user}",
    mode    => 644
  }

  file { "${tomcatInstallationDirectory}/conf/server.xml" :
    ensure    => present,
    content   => template("tomcat/server.xml.erb"),
    owner     => "${bahmni_user}",
    replace   => true,
    mode      => 644,
    require   => Exec["tomcat_untar"]
  }

  file { "${tomcatInstallationDirectory}/conf/tomcat-users.xml" :
    ensure    => present,
    content   => template("tomcat/tomcat-users.xml.erb"),
    owner     => "${bahmni_user}",
    mode      => 644,
    require   => Exec["tomcat_untar"]
  }

  exec{ "change_tomcat_owner" :
    command   => "chown -R ${bahmni_user}:${bahmni_user} ${tomcatInstallationDirectory}",
    path      => "${os_path}",
    require   => Exec["tomcat_untar"]
  }

  exec { "installtomcatservice" :
    provider  => "shell",
    user      => "root",
    command   => "chkconfig --add tomcat",
    require   => Exec["change_tomcat_owner"],
    onlyif    => "chkconfig --list tomcat; [ $? -eq 1 ]"
  }
}