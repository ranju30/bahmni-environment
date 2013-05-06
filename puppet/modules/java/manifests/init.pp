class java {
  require host
  
  $java_path = "${java_home}/${jre_name}/bin/java"

  file { "${java_home}" : 
    ensure => directory,
    mode   => 777
  }

  package { "jre" :
    ensure => installed
  }

	file { "${java}" :
    ensure  => "link",
    target  => "${java_path}",
    require => Package["jre"]
 	}

  exec { "JAVA_HOME env variable" :
    command   => "export JAVA_HOME=${java_home}",
    path      => "${os_path}",
    provider  => shell
  }
}