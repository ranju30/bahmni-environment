class openmrs::config inherits global {
  $os_path="${::global::os_path}"
  $build_output_dir = "${::global::build_output_dir}"
  $deployment_log_file = "${::global::deployment_log_file}"
  $bahmni_release_version = "${::global::bahmni_release_version}"
  

}