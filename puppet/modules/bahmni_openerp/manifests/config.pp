class bahmni_openerp::config inherits global {
  $os_path="${::global::os_path}"
  $bahmni_user="${::global::bahmni_user}"
  $build_output_dir = "${::global::build_output_dir}"
  $temp_dir = "${::global::temp_dir}"
  $deployment_log_expression="${::global::deployment_log_expression}"
  $tomcatInstallationDirectory="${::global::tomcatInstallationDirectory}"
  $add_email_appender = "${::global::add_email_appender}"
  $db_server="${::global::db_server}"
}