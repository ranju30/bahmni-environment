class go-setup {
  require java
  require maven

  package { "go-server" :
    ensure => present;
  }

  package { "go-agent" :
    ensure => present;
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

  file { "/home/${bahmni_user}/startGo.sh" :
    ensure  => present,
    content => template("go-setup/startGo.sh"),
    mode    => 555,
  }

}