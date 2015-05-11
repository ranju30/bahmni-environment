class nagios_remote_host {
  
  package { "nagios-plugins-all" :
    ensure  => "present"
  }
  
  package {"nrpe" : ensure => "installed"}

  service { "nrpe":
      ensure     => running,
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
      require    => Package["nrpe"]
  }

  file { "/etc/nagios/nrpe.cfg":
    content     => template("nagios_remote_host/nrpe.cfg"),
    ensure      => present,
    owner       => "${nagios_user}",
    notify      => Service["nrpe"]
  }


  file { "/usr/lib64/nagios/plugins/check_postgres.pl":
    source      => "puppet:///modules/nagios_remote_host/nagios-plugins/check_postgres.pl",
    owner       => "${nagios_user}",
    group       => "${nagios_user}",
    mode        =>  555,
    require    => Package["nagios-plugins-all"]
  }
  
  file { "/usr/lib64/nagios/plugins/check_exit_status.pl":
    source      => "puppet:///modules/nagios_remote_host/nagios-plugins/check_exit_status.pl",
    owner       => "${nagios_user}",
    group       => "${nagios_user}",
    mode        =>  555,
    require    => Package["nagios-plugins-all"]
  }
  
  file { "/usr/lib64/nagios/plugins/check_scheduled_tasks.py":
    source      => "puppet:///modules/nagios_remote_host/nagios-plugins/check_scheduled_tasks.py",
    owner       => "${nagios_user}",
    group       => "${nagios_user}",
    mode        =>  555,
    require    => Package["nagios-plugins-all"]
}
}