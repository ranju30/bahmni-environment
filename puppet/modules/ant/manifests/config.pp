class ant::config inherits global{
  $bahmni_user="${::global::bahmni_user}"
  $os_path="${::global::os_path}"
  $package_dir="${::global::package_dir}"
  $deployment_log_expression="${::global::deployment_log_expression}"
  $ant_home="${::global::ant_home}"
  $ant_version="${::global::ant_version}"
}