class maven::config inherits global {
  $os_path="${::global::os_path}"
  $bahmni_user="${::global::bahmni_user}"
  $package_dir="${::global::package_dir}"
  $deployment_log_expression="${::global::deployment_log_expression}"
}