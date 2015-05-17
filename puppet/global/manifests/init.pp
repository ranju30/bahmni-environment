class global inherits global::runtime {
  
  $bahmni_user="${::global::runtime::bahmni_user}"
  $bahmni_openerp_required="${::global::runtime::bahmni_openerp_required}"
  $bahmni_openelis_required="${::global::runtime::bahmni_openelis_required}"
  $implementation_name="${::global::runtime::implementation_name}"
  $is_passive_setup="${::global::runtime::is_passive_setup}"
  $support_email="${::global::runtime::support_email}"

## Bahmni Global Config##
  $bahmni_home="/home/${bahmni_user}"
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

  $bahmni_config_dir="/etc/bahmni"
  $temp_dir = "/bahmni_temp"
  $logs_dir = "${temp_dir}/logs"
  $package_dir = "/packages"
  $backup_dir = "/backup"

  $local_repo_path = "${package_dir}/localrepo"
  $packages_servers_dir = "${package_dir}/servers"
  $python_package_dir = "${package_dir}/python-packages"
  $local_repo_name = "local"
  $scripts_dir = "/root/scripts"
  $build_dir = "${package_dir}/build"
  $create_local_repo = $env_create_local_repo ? {
    undef			=> 'true',
    default       => $env_create_local_repo
  }
  $bahmni_yum_repo_url = $go_bahmni_yum_repo_url ? {
    undef			=> 'http://172.18.2.14/localrepo',
    default       => $go_bahmni_yum_repo_url
  }
  
## End Bahmni Global Config ##

  

##tomcat##
  $tomcat_version="8.0.12"
  $tomcatInstallationDirectory = "${bahmni_home}/apache-tomcat-${tomcat_version}"
  $webapps_dir="${tomcatInstallationDirectory}/webapps"

  $uploadedFilesDirectory="${bahmni_home}/uploaded-files"
  $patientImagesDirectory="${bahmni_home}/patient_images"
  $patientImagesUrl="${bahmni_home}/patient_images"
  $documentBaseDirectory="${bahmni_home}/document_images"
  $uploadedResultsDirectory="${bahmni_home}/uploaded_results"

##openmrs
  $openmrs_distro_file_name_prefix="distro-${bahmni_release_version}"

}