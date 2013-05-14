class java {
  require yum-repo
  
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