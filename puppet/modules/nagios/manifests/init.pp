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

    # This package is required for the check_activemq plugin to run
    package { "perl-libwww-perl" :
        ensure  => "present",
        require => Package["nagios-plugins-all"]
    }

    package { "perl-Time-HiRes" :
        ensure  => "present",
        require => Package["perl-libwww-perl"]
    }

    file { "/tmp/nagios_package" :
        ensure  => "directory",
        require => Package["perl-Time-HiRes"]
    }

    exec { "download_bahmni_nagios_configurations" :
        command => "git clone https://github.com/Bhamni/nagios-conf.git /tmp/nagios_package",
        path => "${os_path}",
        require => File["/tmp/nagios_package"]
    }

    file { "/etc/nagios" :
        ensure  => "directory",
        require => Exec["download_bahmni_nagios_configurations"]
    }

    file { "/etc/nagios/objects/":
        source    => "/tmp/nagios_package/objects/",
        recurse   => true,
        purge     => true,
        require   => File["/etc/nagios"]
    }

    file { "/etc/nagios/objects/hosts.cfg":
        source    => "/tmp/nagios_package/${nagios_host_file_path}",
        require   => File["/etc/nagios/objects/"]
    }

    file { "/usr/lib64/nagios/plugins/":
        source    => "/tmp/nagios_package/plugins/",
        recurse   => true,
        owner => "nagios",
        group => "nagios",
        mode      =>  554,
        require   => File["/etc/nagios/objects/hosts.cfg"]
    }

    exec { "setup_object_files_in_config" :
        command => "sed -i 's/^cfg_file\s*=.*$//g' /etc/nagios/nagios.cfg ; find /etc/nagios/objects -name \\*cfg | sed 's/\\(.*\\)/cfg_file=\\1/g' >> /etc/nagios/nagios.cfg",
        require => File["/usr/lib64/nagios/plugins/"]
    }

    service { "nagios":
        ensure  => running,
        require => Exec["setup_object_files_in_config"] 
    }

    exec { "remove_nagios_package" :
        command => "rm -rf /tmp/nagios_package",
        path => "${os_path}",
        require   => Service["nagios"]
    }
}