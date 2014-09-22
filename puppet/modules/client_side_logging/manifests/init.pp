class client_side_logging() {
  package { "mod_wsgi" : ensure => "installed" }

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