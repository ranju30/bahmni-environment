class go-setup {

  package { "go-server" :
    ensure => present;
  }

  package { "go-agent" :
    ensure => present;
  }

  user { "go" :
   groups => ["${userName}"],
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