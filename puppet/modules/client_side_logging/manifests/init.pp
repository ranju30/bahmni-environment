class client_side_logging inherits client_side_logging::config {
  package { "mod_wsgi" : ensure => "installed" }
  exec { "flask" :
    command => "easy_install flask",
    path => "${config::os_path}",
    cwd => "${temp_dir}"
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
