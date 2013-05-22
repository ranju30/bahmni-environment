class bahmni-service($status) {
  service { "tomcat" :
    ensure => "${status}",
    name   => "tomcat",
    path   => "${os_path}"
  }

  service { "openerp" :
  	ensure => "${status}",
  	name	 => "openerp",
  	path 	 => "${os_path}"
  }

  service { "httpd" :
    ensure      => "${status}",
    enable      => true,
    require     => Service["tomcat"]
  }
}