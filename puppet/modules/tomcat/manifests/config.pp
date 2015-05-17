class tomcat::config inherits global {
  $os_path="${::global::os_path}"
  $bahmni_user="${::global::bahmni_user}"
  $bahmni_home="${::global::bahmni_home}"
  $deployment_log_expression="${::global::deployment_log_expression}"
  $tomcat_version="${::global::tomcat_version}"
  $tomcatInstallationDirectory="${::global::tomcatInstallationDirectoryy}"
  
}