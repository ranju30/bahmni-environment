class openmrs::config inherits global {
  $os_path="${::global::os_path}"
  $build_output_dir = "${::global::build_output_dir}"
  $deployment_log_file = "${::global::deployment_log_file}"
  $add_email_appender = "${::global::add_email_appender}"
  $db_server="${::global::db_server}"
}