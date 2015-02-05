class nagios {
    require yum_repo
    
    package { "nagios" :
        ensure  =>  "present"
    }

    package { "nagios-plugins-all" :
        ensure  => "present",
        require => Package["nagios"]
    }

    package { "nrpe" :
        ensure  => "present",
        require => Package["nagios-plugins-all"]
    }

    file { "/etc/nagios/nrpe.cfg":
        content     => template("nagios/nrpe.cfg"),
        ensure      => present,
        owner       => "${nagios_user}",
        notify      => Service["nrpe"]
    }

    service { "nrpe":
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package["nrpe"]
    }

    package { "nagios-plugins-nrpe" :
        ensure  => "present",
        require => Service["nrpe"]
    }

    package { "mailx" :
        ensure  =>  "present"
    }

    file { "/usr/lib64/nagios/plugins/check_postgres.pl":
        source      => "puppet:///modules/nagios/nagios-plugins/check_postgres.pl",
        owner       => "${nagios_user}",
        group       => "${nagios_user}",
        mode        =>  555,
        require    => Service["nrpe"]
    }
    
    file { "/usr/lib64/nagios/plugins/check_scheduled_tasks.py":
        source      => "puppet:///modules/nagios/nagios-plugins/check_scheduled_tasks.py",
        owner       => "${nagios_user}",
        group       => "${nagios_user}",
        mode        =>  555,
        require    => Service["nrpe"]
    }    
}