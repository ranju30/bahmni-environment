class nagios_server::config inherits global {
  $os_path="${::global::os_path}"
  $implementation_name= "${::global::implementation_name}"
}