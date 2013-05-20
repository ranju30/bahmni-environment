class nagios {
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

    service { "nrpe":
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require => Package["nrpe"]
    }

    package { "nagios-plugins-nrpe" :
        ensure  => "present",
        require => Service["nrpe"]
    }

    service { "nagios":
        ensure  => running,
        require => Exec["setup_object_files_in_config"] 
    }
}