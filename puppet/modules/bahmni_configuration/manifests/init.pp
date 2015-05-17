# This class only has the configuration setup for bahmni core and registration
# The module installation is in /deploy folder
class bahmni_configuration inherits bahmni_configuration::config {
  
  $bahmnicore_properties = "/home/${::config::bahmni_user}/.OpenMRS/bahmnicore.properties"

  file { "${patientImagesDirectory}" :
    ensure      => directory,
    mode        => 774,
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
  }

  file { "${uploadedResultsDirectory}" :
    ensure      => directory,
    mode        => 774,
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
  }

  file { "${documentBaseDirectory}" :
    ensure => directory,
    mode   => 774,
    owner  => "${::config::bahmni_user}",
    group  => "${::config::bahmni_user}",
  }

  exec { "change_group_rights_for_document_images_content" :
    provider => "shell",
    command => "chown -R ${::config::bahmni_user}:${::config::bahmni_user} ${documentBaseDirectory}; chmod -R 774 ${documentBaseDirectory}; ",
    path => "${config::os_path}",
    require => File["${documentBaseDirectory}"]
  }

  file { "${::config::uploadedFilesDirectory}" :
    ensure => directory,
    mode   => 774,
    owner  => "${::config::bahmni_user}",
    group  => "${::config::bahmni_user}",
  }

  file { ["${::config::uploadedFilesDirectory}/mrs"] :
    ensure => directory,
    mode   => 774,
    owner  => "${::config::bahmni_user}",
    group  => "${::config::bahmni_user}",
    require => File["${::config::uploadedFilesDirectory}"],
  }

  file { "${httpd_deploy_dir}/patient_images" :
    ensure  => "link",
    target  => "${patientImagesDirectory}",
    require => File["${patientImagesDirectory}"],
  }

  file { "${bahmnicore_properties}" :
    ensure      => present,
    content     => template("bahmni_configuration/bahmnicore.properties.erb"),
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
    mode        => 664
  }
}
