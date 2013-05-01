class java {
  $java_path = "${java_home}/${jre_name}/bin/java"

  file { "${java_home}" : 
    ensure => "directory"
  }

	exec { "untar" :
  	command => "tar zxf ${package_dir}/${java_installer_file} -C ${java_home}",
    provider => "shell",
    onlyif  => "test ! -f ${java_path}",
    path => "${os_path}"
  }

	file { "${java}" :
    ensure => "link",
    target => "${java_path}"
 	}

  exec { "set Java env variable" :
    command => "export JAVA_HOME=${java_home}",
    path    => "${os_path}",
    provider => "shell"
  }
}