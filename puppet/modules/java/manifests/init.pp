class java {
  require host
  
  $java_path = "${java_home}/${jre_name}/bin/java"

  file { "${java_home}" : 
    ensure => directory,
    mode   => 777
  }

	exec { "untar" :
  	command => "tar zxf ${package_dir}/${java_installer_file} -C ${java_home}",
    provider => "shell",
    onlyif  => "test ! -f ${java_path}",
    path => "${os_path}",
    require => File["${java_home}"]
  }

	file { "${java}" :
    ensure  => "link",
    target  => "${java_path}",
    require => Exec["untar"]
 	}

  exec { "set Java env variable" :
    command   => "export JAVA_HOME=${java_home}",
    path      => "${os_path}",
    provider  => "shell"
  }
}