class java {
  $java_path = "${java_home}/${jre_name}/bin/java"

	exec { "download" :
  	command => "wget -O ${temp_dir}/${java_installer_file} ${package_download_url}/${java_installer_file}",
    timeout => 120,
    provider => "shell",
    onlyif  => "test ! -f ${temp_dir}/${java_installer_file}"
  }

  file { "${java_home}" : 
    ensure => "directory"
  }

	exec { "untar" :
  	command => "tar zxf ${temp_dir}/${java_installer_file} -C ${java_home}",
    provider => "shell",
    onlyif  => "test ! -f ${java_path}",
    path => "${os_path}"
  }

	file { "${java}" :
    ensure => "link",
    target => "${java_path}"
 	}
}