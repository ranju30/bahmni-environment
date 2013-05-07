# Doesn't have dependency on openmrs because this would be used during deployment
class openmrs-modules ( $omod_file_name ) {
  exec { "start openmrs" :
    command     => "sh ${temp_dir}/start-tomcat-webapp.sh http://localhost:${tomcatHttpPort}/openmrs ${log_expression}",
    user        => "${bahmni_user}",
    path        => "${os_path}",
    require     => [File["${temp_dir}/start-tomcat-webapp.sh"], Exec["catalina"]],
    timeout     => 30
  }

  file { "deploy_openmrs_modules.sh" :
    ensure      => present,
    content     => template("openmrs-modules/deploy-openmrs-modules.sh"),
    path 				=> "${temp_dir}/deploy-openmrs-modules.sh",
    owner       => "${bahmni_user}",
    mode        => 544
  }

  exec { "deploy openmrs modules" :
    command   => "${temp_dir}/deploy-openmrs-modules.sh ${openmrs_password} webservices.rest19ext-omodfile idgen.module-omodfile bahmnicore-omodfile",
    provider  => "shell",
    path      => "${os_path}",
    require   => File["deploy_openmrs_modules.sh"],
    cwd       => "${temp_dir}"
  }
}