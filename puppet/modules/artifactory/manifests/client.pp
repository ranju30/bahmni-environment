class artifactory::client {
    file { "${m2_folder}/settings.xml" :
      ensure      => present,
      content     => template("artifactory/client/settings.xml.erb"),
      mode        => 644,
    }
}