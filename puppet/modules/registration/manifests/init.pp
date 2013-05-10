class registration {
  file { "${deployDirectory}" :
      ensure      => directory,
      owner       => "${bahmni_user}",
      group       => "${bahmni_user}",
      mode        => 644,
  }

  exec { "unzip" :
    command   => "unzip -q -o ${deployablesDirectory}/registration.zip -d ${registrationAppDirectory}",
    provider  => shell
    require => File["${deployDirectory}"],
  }
}