class bahmni_jasperreports::config inherits global {
  $os_path="${::global::os_path}"
  $build_output_dir = "${::global::build_output_dir}"
  $implementation_name = "${::global::implementation_name}"
  $deployment_log_expression="${::global::deployment_log_expression}"
  $reports_environment="${::global::reports_environment}"
  $report_zip_source_url = "${::global::implementation_name}" ? {
    undef       => "https://github.com/jss-emr/jss-reports/archive/master.zip",
    "jss"       => "https://github.com/jss-emr/jss-reports/archive/master.zip",
    default        => "https://github.com/jss-emr/jss-reports/archive/master.zip",
    "search"       => "https://github.com/Bhamni/search-reports/archive/master.zip",
    "lokbiradari"  => "https://github.com/Bhamni/lokbiradari-reports/archive/master.zip",
    "possible"  => "https://github.com/Bhamni/possible-reports/archive/master.zip"
  }
}