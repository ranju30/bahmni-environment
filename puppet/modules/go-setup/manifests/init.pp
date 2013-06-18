class go-setup {

  package { "go-server" :
    ensure => present;
  }

  package { "go-agent" :
    ensure => present;
  }

  # file { "/home/go" :
  #   ensure  => directory,
  #   mode    => 775,
  #   require     => Package["go-server", "go-agent"]
  # }

  # user { "go" :
  #   ensure      => present,
  #   shell       => "/bin/bash",
  #   home        => "/home/go",
  #   gid         => "go",
  #   groups      => ["${userName}"], # add 'go' user to 'jss' group.
  #   require     => File["/home/go"],
  # }
 
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