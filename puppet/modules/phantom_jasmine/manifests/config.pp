class phantom_jasmine::config {
  $os_path="${::global::os_path}"
  $bahmni_user="${::global::bahmni_user}"
  $build_output_dir = "${package_dir}/build"
  $deployment_log_expression="${::global::deployment_log_expression}"
  $openmrs_distro_file_name_prefix="${::global::openmrs_distro_file_name_prefix}"
}