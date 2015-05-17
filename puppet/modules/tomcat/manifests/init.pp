class tomcat {
  include tomcat_base
  include tomcat::tomcat_conf
}

class tomcat_base {
  require host
  require java
  
  exec { "tomcat_untar" :
    command   => "tar -zxf ${packages_servers_dir}/apache-tomcat-${::config::tomcat_version}.tar.gz -C ${::config::bahmni_home} ${::config::deployment_log_expression}",
    user      => "${::config::bahmni_user}",
    creates   => "${::config::tomcatInstallationDirectory}",
    provider  => shell
  }
  
  exec { "adds_juli_adapters" :
    command   => "cp ${packages_servers_dir}/tomcat-juli-adapters.jar ${::config::tomcatInstallationDirectory}/lib/",
    user      => "${::config::bahmni_user}",
    provider  => shell,
    require   => Exec["tomcat_untar"]
  }
  
  exec { "adds_juli" :
    command   => "cp ${packages_servers_dir}/tomcat-juli.jar ${::config::tomcatInstallationDirectory}/bin/",
    user      => "${::config::bahmni_user}",
    provider  => shell,
    require   => Exec["tomcat_untar"]
  }
  
  exec { "adds_log4j" :
    command   => "cp ${packages_servers_dir}/log4j-1.2.17.jar ${::config::tomcatInstallationDirectory}/lib/",
    user      => "${::config::bahmni_user}",
    provider  => shell,
    require   => Exec["tomcat_untar"]
  }
}