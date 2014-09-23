class client_side_logging() {
  package { "mod_wsgi" : ensure => "installed" }
  $python_temp_dir = "${temp_dir}/python"
  $os_path = "/sbin:/bin:/usr/sbin/:/usr/bin:/usr/local/bin:/usr/local/sbin"
  exec { "flask" :
    command => "easy_install flask",
    path => "${os_path}",
    cwd => "${python_temp_dir}",
  }

  file { "${python_site_packages}/${client_side_logging}" :
    ensure  => "directory",
    source  => "${build_dir}/${client_side_logging}",
    owner   => "${bahmni_user}",
    recurse => "true",
  }

  file { "${httpd_deploy_dir}/${client_side_logging}" :
    ensure  => "directory",
    source  => "${build_dir}/${client_side_logging}",
    owner   => "${bahmni_user}",
    recurse => "true",
  }

  file { "${httpd_log_directory}/client-side-logs":
    ensure => "directory",
    owner => "apache",
    group => "apache",
    mode => "755"
  }

  file { "${httpd_log_directory}/client-side-logs/client-side.log":
    ensure => "file",
    owner => "apache",
    group => "apache",
    mode => "755"
  }

}