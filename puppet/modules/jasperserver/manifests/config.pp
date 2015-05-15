class jasperserver::config inherits global {
  $jasperHome = "${::global::jasperHome}"

  $jasperTomcatHome = $tomcatInstallationDirectory
  $jasperDbType = "mysql"
  $jasperDbHost = $passive_db_server_ip ? {
    undef => $db_server,
    default => $passive_db_server_ip
  }
  $jasperDbUsername = "root"
  $jasperDbPassword = "password"
  $jasperDbName = "jasperserver"

  $log_file = "${logs_dir}/jasperserver-module.log"
  $log_expression = ">> ${log_file} 2>> ${log_file}"
  $default_master_properties = "${jasperHome}/buildomatic/default_master.properties"
  $jasper_install_log_file = "${logs_dir}/jasper-install.log"
  $jasper_installation_log_expression = ">> ${$jasper_install_log_file} 2>> ${$jasper_install_log_file}"
  $jasper_webapp_location =  "${tomcatInstallationDirectory}/webapps/jasperserver"
  $do_js_setup_script = "${jasperHome}/buildomatic/bin/do-js-setup.sh"

}
