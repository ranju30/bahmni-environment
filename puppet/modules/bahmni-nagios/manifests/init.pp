class bahmni-nagios{
    require nagios

    file { "/etc/nagios/objects":
        ensure      => directory,
        recurse     => true,
        owner       => "${nagios_user}"
    }

    file { "/etc/nagios/objects/hosts.cfg":
        content     => template("bahmni-nagios/localhost.cfg")",
        ensure      => preset,
        owner       => "${nagios_user}"
        require     => File["/etc/nagios/objects"]
    }
    
    file { "/etc/nagios/objects/commands.cfg":
        content     => template("bahmni-nagios/commands.cfg")",
        ensure      => preset,
        owner       => "${nagios_user}"
        require     => File["/etc/nagios/objects"]
    }

    file { "/etc/nagios/objects/contacts.cfg":
        content     => template("bahmni-nagios/contacts.cfg")",
        ensure      => preset,
        owner       => "${nagios_user}"
        require     => File["/etc/nagios/objects"]
    }

    file { "/etc/nagios/objects/templates.cfg":
        content     => template("bahmni-nagios/templates.cfg")",
        ensure      => preset,
        owner       => "${nagios_user}"
        require     => File["/etc/nagios/objects"]
    }

    file { "/etc/nagios/objects/timeperiods.cfg":
        content     => template("bahmni-nagios/timeperiods.cfg")",
        ensure      => preset,
        owner       => "${nagios_user}"
        require     => File["/etc/nagios/objects"]
    }

    file { "/etc/nagios/objects/nrpe.cfg":
        content     => template("bahmni-nagios/nrpe.cfg")",
        ensure      => preset,
        owner       => "${nagios_user}"
        require     => File["/etc/nagios/objects"]
    }

    file{ "${nagios_plugins_dir}":
        ensure  => directory
    }

    file { "/usr/lib64/nagios/plugins/":
        source      => "${nagios_plugins_dir}",
        recurse     => true,
        owner       => "${nagios_user}",
        group       => "${nagios_user}",
        mode        =>  554,
        require     => File["${nagios_plugins_dir}"]
    }

    exec { "setup_object_files_in_config" :
        command => "sed -i 's/^cfg_file\s*=.*$//g' /etc/nagios/nagios.cfg ; find /etc/nagios/objects -name \\*cfg | sed 's/\\(.*\\)/cfg_file=\\1/g' >> /etc/nagios/nagios.cfg",
        require => File["/usr/lib64/nagios/plugins/"]
    }

    service { "nagios":
        ensure  => running,
        require => Exec["setup_object_files_in_config"] 
    }
}