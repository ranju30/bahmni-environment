class nodes::nagios-server {
  $nagios_server_ip = $bahmni_nagios_server_ip ? { undef => "localhost", default => $bahmni_nagios_server_ip }
  include nagios_server
}