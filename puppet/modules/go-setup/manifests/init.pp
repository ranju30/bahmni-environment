class go-setup {

  package { "go-server" :
    ensure => present;
  }

  package { "go-agent" :
    ensure => present,
    require => Package["go-server"],
  }

  user { "go" :
    ensure      => present,
    # add 'go' user to 'jss' and 'openerp' group.
    groups      => ["${bahmni_user}", "${openerpGroup}"], 
    require     => Package["go-agent"],
  }

  file { "/etc/go/cruise-config.xml" :
    ensure    => present,
    content   => template("go-setup/cruise-config.xml.erb"),
    replace   => true,
    mode      => 666,
    require   => Package["go-server", "go-agent"]
  }

  file { "/etc/hosts" :
    ensure  => present,
    content => template("go-setup/hosts"),
    replace => true,
  }

  service { "go-server" :
    ensure      => running,
    enable      => true,
    require     => File["/etc/go/cruise-config.xml"]
  }

  service { "go-agent" :
    ensure      => running,
    enable      => true,
    require     => Service["go-server"]
  }

}