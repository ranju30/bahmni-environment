# This class only configuration setup for bahmni core and registation
# The module installation is in jss-scm/deploy folder
class bahmni ( $tomcatInstallationDirectory) {
    file { "${imagesDirectory}" :
        ensure      => directory,
        owner       => "${jssUser}",
        group       => "${jssUser}",
    }

	 file { "$tomcatInstallationDirectory/webapps/patient_images":
       ensure => "link",
       target => "${imagesDirectory}",
       require => File["${imagesDirectory}"],
    }

   file { "/home/${jssUser}/.OpenMRS/bahmnicore.properties" :
        ensure      => present,
        content     => template("bahmni/bahmnicore.properties.erb"),
        owner       => "${jssUser}",
        group       => "${jssUser}",
        require    => File["/home/${jssUser}/.OpenMRS"],
    }
}
