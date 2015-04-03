class java {
  require yum_repo

  $java_home = "/usr/java/jdk1.7.0_21"

  package { "jdk" :
    ensure => installed
  }

  file { "jdk_home_path" :
    path    => "/etc/profile.d/java.sh",
    ensure  => present,
    content => template ("java/java.sh"),
    mode    => 664,
    require => Package["jdk"]
  }
}