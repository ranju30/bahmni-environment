class bahmni_distro::config {
  $bahmni_user="${::global::bahmni_user}"
  $os_path="${::global::os_path}"
  $build_output_dir = "${package_dir}/build"
  $deployment_log_expression="${::global::deployment_log_expression}"
  $openmrs_distro_file_name_prefix="${::global::openmrs_distro_file_name_prefix}"
}