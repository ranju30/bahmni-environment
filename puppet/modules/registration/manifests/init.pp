class registration {
  exec { "unzip" :
    command   => "unzip -q -o ${deployablesDirectory}/registration.zip -d ${registrationAppDirectory}",
    user      => "${bahmni_user}",
    creates   => "${registrationAppDirectory}",
    provider  => shell
  }
}