class tomcat::tomcat_conf inherits tomcat::config {
  
  require tomcat_base
  
  file { "CATALINA_OPTS" :
    path    => "${::config::tomcatInstallationDirectory}/bin/setenv.sh",
    ensure  => present,
    content => template ("tomcat/setenv.sh"),
    owner   => "${::config::bahmni_user}",
    mode    => 664,
  }
  
  file { "/etc/init.d/tomcat" :
    ensure      => present,
    content     => template("tomcat/tomcat.initd.erb"),
    mode        => 777,
    group       => "root",
    owner       => "root",
  }
  
  file { "catalina.sh_with_log4j_properties_path_info" :
    path        => "${::config::tomcatInstallationDirectory}/bin/catalina.sh",
    ensure      => present,
    content     => template("tomcat/catalina.sh.erb"),
    owner       => "${::config::bahmni_user}",
    replace     => true,
    mode        => 774,
  }
  
  
  file { "${::config::tomcatInstallationDirectory}/conf/server.xml" :
    ensure    => present,
    content   => template("tomcat/server.xml.erb"),
    owner     => "${::config::bahmni_user}",
    replace   => true,
    mode      => 664,
  }
  
  file { "${::config::tomcatInstallationDirectory}/conf/context.xml" :
    ensure    => present,
    content   => template("tomcat/context.xml.erb"),
    owner     => "${::config::bahmni_user}",
    replace   => true,
    mode      => 664,
  }
  
  file { "log4j_properties_file_for_tomcat" :
    path      => "${::config::tomcatInstallationDirectory}/lib/log4j.properties",
    ensure    => present,
    content   => template("tomcat/log4j.properties.erb"),
    owner     => "${::config::bahmni_user}",
    replace   => true,
    mode      => 664,
  }
  
  file { "delete_original_tomcat_logging_properties_file" :
    path      => "${::config::tomcatInstallationDirectory}/conf/logging.properties",
    ensure    => absent,
  }
  
  file { "${::config::tomcatInstallationDirectory}/conf/web.xml" :
    ensure      => present,
    content     => template("tomcat/web.xml.erb"),
    group       => "${::config::bahmni_user}",
    owner       => "${::config::bahmni_user}",
    replace     => true,
  }
  
  file { "${::config::tomcatInstallationDirectory}/conf/tomcat-users.xml" :
    ensure    => present,
    content   => template("tomcat/tomcat-users.xml.erb"),
    owner     => "${::config::bahmni_user}",
    mode      => 664,
  }
  
  # Mujir - recursively doing this through file resource eats up time. Hence the exec below.
  file { "${::config::tomcatInstallationDirectory}" :
    ensure => directory,
    mode   => 776,
    owner  => "${::config::bahmni_user}",
    group  => "${::config::bahmni_user}",
  }
  
  file { "${::config::tomcatInstallationDirectory}/docs" :
    ensure    => absent,
    recurse   => true,
    force     => true,
    purge     => true,
    require => File["${::config::tomcatInstallationDirectory}"],
  }
  
  file { "${::config::tomcatInstallationDirectory}/examples" :
    ensure    => absent,
    recurse   => true,
    force     => true,
    purge     => true,
    require => File["${::config::tomcatInstallationDirectory}"],
  }
  
  exec { "change_group_rights_for_tomcatInstallationDirectory" :
    provider => "shell",
    command => "chown -R ${::config::bahmni_user}:${::config::bahmni_user} ${::config::tomcatInstallationDirectory}; chmod -R 776 ${::config::tomcatInstallationDirectory}; ",
    path => "${config::os_path}",
    require => File["${::config::tomcatInstallationDirectory}"],
  }
  
  exec { "register_tomcat_as_a_service" :
    command   => "chkconfig --add /etc/init.d/tomcat",
    user      => "root",
    provider  => shell,
    require   => [File["${::config::tomcatInstallationDirectory}"], File["/etc/init.d/tomcat"]],
  }
  
  service { "tomcat":
    enable    => true,
    ensure => running,
    require   => Exec["register_tomcat_as_a_service"],
  }
}
