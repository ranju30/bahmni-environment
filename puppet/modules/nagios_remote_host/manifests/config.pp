class nagios_remote_host::config inherits global {
  $nagios_server_ip="${::global::runtime::nagios_server_ip}"
}