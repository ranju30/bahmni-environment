$build_output_dir = "${package_dir}/build"

$deployment_log_file = "${logs_dir}/bahmni_deploy.log"
$deployment_log_expression = ">> ${deployment_log_file} 2>> ${deployment_log_file}"

$bahmni_openerp_branch = "master"
$bahmni_openerp_temp_dir = "${temp_dir}/bahmni-openerp"
$openerp_base_data_dump = "bahmni-openerp-base-data.sql"
$bahmni_version = "0.2-SNAPSHOT"
$jss_registration_csv = "RegistrationMaster.csv"
$number_of_migrator_threads = 1

file { "${deployment_log_file}" :
  ensure      => present,
  owner       => "${bahmni_user}",
  group       => "${bahmni_user}",
  mode        => 666,
  content     => "",
}

# Mujir - when this directory is non-empty, this takes a long time.
# Should we change to chown -R openrp:openerp, and chmod 664?
file { "${httpd_deploy_dir}" :
  ensure      => directory,
  owner       => "${bahmni_user}",
  group       => "${bahmni_user}",
  mode        => 775,
}
exec { "change_rights_for_httpd_deploy_dir" :
  provider => "shell",
  command => "chown -R ${bahmni_user}:${bahmni_user} ${httpd_deploy_dir}; chmod -R ug+w,a+r ${httpd_deploy_dir}; umask 223;",
  path => "${os_path}",
  require => File["${httpd_deploy_dir}"],
}
