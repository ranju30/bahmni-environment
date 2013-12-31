class bahmni-service($status, $tomcat_status) {
  exec { "tomcat" :
    command => "service tomcat ${tomcat_status} ${deployment_log_expression}",
    provider => shell,
    path   => "${os_path}",
  }

  service { "openerp" :
  	ensure => "${status}",
  	name	 => "openerp",
  	path 	 => "${os_path}"
  }

  service { "httpd" :
    ensure      => "${status}",
    enable      => true,
    require     => Exec["tomcat"],
  }
}