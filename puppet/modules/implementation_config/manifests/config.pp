class implementation_config::config inherits global {
  $os_path="${::global::os_path}"
  $bahmni_user="${::global::bahmni_user}"
  $build_output_dir = "${::global::build_output_dir}"
  $deployment_log_expression="${::global::deployment_log_expression}"
}