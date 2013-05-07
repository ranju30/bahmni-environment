class java {
  require host
  
  package { "jre" :
    ensure => installed
  }
  
  file { "java_home_path" :
    path    => "/etc/profile.d/java.sh",
    ensure  => present,
    content => template ("java/java.sh"),
    mode    => 644
  }
}