class bahmni_jasperreports::config inherits global {
  $jasperHome = "${::global::jasperHome}"
  $report_zip_source_url = $implementation_name ? {
    undef       => "https://github.com/jss-emr/jss-reports/archive/master.zip",
    "jss"       => "https://github.com/jss-emr/jss-reports/archive/master.zip",
    default        => "https://github.com/jss-emr/jss-reports/archive/master.zip",
    "search"       => "https://github.com/Bhamni/search-reports/archive/master.zip",
    "lokbiradari"  => "https://github.com/Bhamni/lokbiradari-reports/archive/master.zip",
    "possible"  => "https://github.com/Bhamni/possible-reports/archive/master.zip"
  }
}