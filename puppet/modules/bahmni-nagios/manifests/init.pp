class bahmni-nagios-cfg {
    require nagios

    file { "/etc/nagios/objects":
        ensure      => directory,
        recurse     => true,
        owner       => "${nagios_user}",
        require     => Class["nagios"]
    }

    file { "/etc/nagios/objects/windows.cfg":
        ensure      => absent,
        require     => Class["nagios"]
    }

    file { "/etc/nagios/objects/printer.cfg":
        ensure      => absent,
        require     => Class["nagios"]
    }

    file { "/etc/nagios/objects/switch.cfg":
        ensure      => absent,
        require     => Class["nagios"]
    }

    file { "/etc/nagios/objects/localhost.cfg":
        content     => template("bahmni-nagios/localhost-${implementation_name}.cfg"),
        ensure      => present,
        owner       => "${nagios_user}",
        notify      => Service["nagios"],
        require     => File["/etc/nagios/objects"],
    }
    
    file { "/etc/nagios/objects/commands.cfg":
        content     => template("bahmni-nagios/commands.cfg"),
        ensure      => present,
        owner       => "${nagios_user}",
        notify      => Service["nagios"],
        require     => File["/etc/nagios/objects"]
    }

    file { "/etc/nagios/objects/contacts.cfg":
        content     => template("bahmni-nagios/contacts.cfg"),
        ensure      => present,
        owner       => "${nagios_user}",
        notify      => Service["nagios"],
        require     => File["/etc/nagios/objects"]
    }

    file { "/etc/nagios/objects/templates.cfg":
        content     => template("bahmni-nagios/templates.cfg"),
        ensure      => present,
        owner       => "${nagios_user}",
        notify      => Service["nagios"],
        require     => File["/etc/nagios/objects"]
    }

    file { "/etc/nagios/objects/timeperiods.cfg":
        content     => template("bahmni-nagios/timeperiods.cfg"),
        ensure      => present,
        owner       => "${nagios_user}",
        notify      => Service["nagios"],
        require     => File["/etc/nagios/objects"]
    }
}


class bahmni-nagios-server {
    require nagios
    require bahmni-nagios-cfg

    exec { "setup_object_files_in_config" :
        command => "sed -i 's/^cfg_file\s*=.*$//g' /etc/nagios/nagios.cfg && find /etc/nagios/objects -name \\*cfg | sed 's/\\(.*\\)/cfg_file=\\1/g' >> /etc/nagios/nagios.cfg",
        path    => "${os_path}",
        require => Class["bahmni-nagios-cfg"],
        notify  => Service["nagios"],
    }

    package { "perl-Time-HiRes":
        ensure => installed,
    }

    service { "nagios":
        enable => true,
        ensure => running
    }
}

class bahmni-nagios-client {
    require nagios

    service { "nagios":
        enable => false,
        ensure => stopped
    }
}

class bahmni-nagios {
    case $nagios_machine_type {
        "server": {
            require bahmni-nagios-server
        }
        "client": {
            require bahmni-nagios-client 
        }
    }
}