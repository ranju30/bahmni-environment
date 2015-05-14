$reports_environment = $bahmni_reports_environment ? {
  undef     => "default",
  default       => $bahmni_reports_environment
}