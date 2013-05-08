# This class only has the configuration setup for bahmni core and registation
# The module installation is in /deploy folder
class bahmni {
    $bahmnicore_properties = "/home/${bahmni_user}/.OpenMRS/bahmnicore.properties"

    file { "${imagesDirectory}" :
        ensure      => directory,
        owner       => "${bahmni_user}",
        group       => "${bahmni_user}",
    }

	 file { "$tomcatInstallationDirectory/webapps/patient_images":
       ensure => "link",
       target => "${imagesDirectory}",
       require => File["${imagesDirectory}"],
    }

   file { "${bahmnicore_properties}" :
        ensure      => present,
        content     => template("bahmni/bahmnicore.properties.erb"),
        owner       => "${bahmni_user}",
        group       => "${bahmni_user}",
        mode        => 644,
    }
}
