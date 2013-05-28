class nagios {
    require yum-repo

    package { "epel" :
        provider => rpm,
        ensure => "present",
        source => "http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
    }
    
    package { "nagios" :
        ensure => "present",
    }

    package { "nagios-plugins-all" :
        ensure  => "present",
    }

    package { "nrpe" :
        ensure  => "present",
    }

    package { "nagios-plugins-nrpe" :
        ensure  => "present",
    }
}