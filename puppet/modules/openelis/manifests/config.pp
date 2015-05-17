class openelis::config inherits global {
  $os_path="${::global::os_path}"
  $bahmni_user="${::global::bahmni_user}"
  $build_output_dir = "${::global::build_output_dir}"
  $ant_home="${::global::ant_home}"
  $deployment_log_file="${::global::deployment_log_file}"
  $uploadedFilesDirectory="${::global::uploadedFilesDirectory}"
  $add_email_appender = "${::global::add_email_appender}"
}