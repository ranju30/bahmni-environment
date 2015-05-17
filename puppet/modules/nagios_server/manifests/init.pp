class bahmni_nagios_cfg inherits nagios_server::config {

  $openelis_username="admin"
  $openelis_password="adminADMIN\!"
  $nagios_user = "nagios"
  $nagios_openmrs_user=admin
  $nagios_openmrs_user_password=test

  file { "/etc/nagios/objects":
    ensure      => directory,
    recurse     => true,
    owner       => "${nagios_user}",
    require     => Class["nagios_server"]
  }

  file { "/etc/nagios/objects/windows.cfg":
    ensure      => absent,
    require     => Class["nagios_server"]
  }

  file { "/etc/nagios/objects/printer.cfg":
    ensure      => absent,
    require     => Class["nagios_server"]
  }

  file { "/etc/nagios/objects/switch.cfg":
    ensure      => absent,
    require     => Class["nagios_server"]
  }

  file { "/etc/nagios/objects/localhost.cfg":
    content     => template("nagios_server/localhost_hosts.cfg", "nagios_server/localhost_active_app.cfg", 
      "nagios_server/localhost_active_db.cfg", "nagios_server/localhost_passive_app.cfg", 
      "nagios_server/localhost_passive_db.cfg"),
    ensure      => present,
    owner       => "${nagios_user}",
    notify      => Service["nagios"],
    require     => File["/etc/nagios/objects"],
  }

  file { "/etc/nagios/objects/commands.cfg":
    content     => template("nagios_server/commands.cfg"),
    ensure      => present,
    owner       => "${nagios_user}",
    notify      => Service["nagios"],
    require     => File["/etc/nagios/objects"]
  }

  file { "/etc/nagios/objects/contacts.cfg":
    content     => template("nagios_server/contacts.cfg"),
    ensure      => present,
    owner       => "${nagios_user}",
    notify      => Service["nagios"],
    require     => File["/etc/nagios/objects"]
  }

  file { "/etc/nagios/objects/templates.cfg":
    content     => template("nagios_server/templates.cfg"),
    ensure      => present,
    owner       => "${nagios_user}",
    notify      => Service["nagios"],
    require     => File["/etc/nagios/objects"]
  }

  file { "/etc/nagios/objects/timeperiods.cfg":
    content     => template("nagios_server/timeperiods.cfg"),
    ensure      => present,
    owner       => "${nagios_user}",
    notify      => Service["nagios"],
    require     => File["/etc/nagios/objects"]
  }
}

class nagios_server {

  if $active_app_ip == undef { fail("Active App ip cannot be empty.") }
  if $active_db_ip == undef { fail("Active DB ip cannot be empty.") }
  if $passive_app_ip == undef { fail("Passive App ip cannot be empty.") }
  if $passive_db_ip == undef { fail("Passive DB ip cannot be empty.") }

  $active_app_host_name = "active_app"
  $active_db_host_name = "active_db"
  $passive_app_host_name = "passive_app"
  $passive_db_host_name = "passive_db"
  
  require yum_repo

  package { "nagios" :
    ensure  =>  "present"
  }

  package { "nagios-plugins-nrpe" :
    ensure  => "present"
  }

  package { "mailx" :
    ensure  =>  "present"
  }
  require bahmni_nagios_cfg

  service { "nagios":
    enable => true,
    ensure => running
  }

  exec { "setup_object_files_in_config" :
    command => "sed -i 's/^cfg_file\s*=.*$//g' /etc/nagios/nagios.cfg && find /etc/nagios/objects -name \\*cfg | sed 's/\\(.*\\)/cfg_file=\\1/g' >> /etc/nagios/nagios.cfg",
    path    => "${config::os_path}",
    require => Class["bahmni_nagios_cfg"],
    notify  => Service["nagios"],
  }

  package { "perl-Time-HiRes":
    ensure => installed,
  }
}