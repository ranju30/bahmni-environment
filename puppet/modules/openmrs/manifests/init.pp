class openmrs {
  $bahmnicore_properties = "/home/${bahmni_user}/.OpenMRS/bahmnicore.properties"
  $log4j_xml_file = "${tomcatInstallationDirectory}/webapps/openmrs/WEB-INF/classes/log4j.xml"
  $web_xml_file = "$tomcatInstallationDirectory/webapps/openmrs/WEB-INF/web.xml"

  exec {"install-openmrs" :
    command     => "cp ${package_dir}/openmrs.war ${tomcatInstallationDirectory}/webapps",
    user        => "${bahmni_user}",
    path        => "${os_path}"
  }

  file { "${imagesDirectory}" :
    ensure      => directory,
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  file { "$tomcatInstallationDirectory/webapps/patient_images" :
    ensure => "link",
    target => "${imagesDirectory}"
  }

  file { "/home/${bahmni_user}/.OpenMRS" :
    ensure      => directory,
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  file { "${bahmnicore_properties}" :
    ensure      => present,
    content     => template("openmrs/bahmnicore.properties.erb"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  exec { "unjar openmrs" :
    command   => "unzip -o -q ${package_dir}/openmrs.war -d ${tomcatInstallationDirectory}/webapps/openmrs",
    provider  => "shell",
    path      => "${os_path}"
  }

  file { "${log4j_xml_file}" :
    ensure      => present,
    content     => template("openmrs/log4j.xml.erb"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  file { "${web_xml_file}" :
    ensure      => present,
    content     => template("openmrs/web.xml"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }
}