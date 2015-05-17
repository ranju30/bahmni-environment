class global inherits global::runtime {
  
  $bahmni_user="${::global::runtime::bahmni_user}"
  
## Bahmni Global Config##
  $os_path = "/sbin:/bin:/usr/sbin/:/usr/bin:/usr/local/bin:/usr/local/sbin"
  $package_dir = "/packages"
  $build_output_dir = "${package_dir}/build"
  $ant_version="1.9.1"
  $ant_home="/home/${bahmni_user}/apache-ant-${ant_version}"
  $deployment_log_file = "${logs_dir}/bahmni_deploy.log"

  $deployment_log_expression = ">> ${deployment_log_file} 2>> ${deployment_log_file}"
  file { "${deployment_log_file}" :
    ensure      => present,
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 666,
    content     => "",
  }
## End Jasper Global Config ##

  
  
## Jasper Global Config ##
  $jasperHome = "/usr/local/jasperreports-server-cp-5.0.0-bin"
## End Jasper Global Config ##


##tomcat##
  $tomcat_version="8.0.12"
  $tomcatParentDirectory="/home/${bahmni_user}"
  $tomcatInstallationDirectory = "${tomcatParentDirectory}/apache-tomcat-${tomcat_version}"
  $webapps_dir="${tomcatInstallationDirectory}/webapps"


##openmrs
  $bahmni_release_version="5.6-SNAPSHOT"
  $openmrs_distro_file_name_prefix="distro-${bahmni_release_version}"

}
