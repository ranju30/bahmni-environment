class passive_to_active::mysql{

  notice("mysql switching from slave to master")

  package { "MySQL-server" :
    ensure  => present
  }

  service { "mysql" :
    ensure => running,
    enable => true,
    require => Package["MySQL-server"],
  }

  exec { "stop-slave" :
    command     => "mysql -uroot -ppassword -e \"STOP SLAVE\"",
    provider    => shell,
    user        => "root",
    require     => Service["mysql"],
  }

  exec {"reset-master":
    command => "mysql -uroot -ppassword -e \"RESET MASTER\"",
    provider => shell,
    user => "root",
    require => Exec["stop-slave"]
  }
}