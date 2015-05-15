class artifactory::client inherits artifactory::config {
    file { "${config::m2_folder}/settings.xml" :
      ensure      => present,
      content     => template("artifactory/client/settings.xml.erb"),
      owner       => "${config::maven_user}",
      group       => "${config::maven_user}",
      mode        => 644,
    }
}