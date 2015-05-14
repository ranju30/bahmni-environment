import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"

stage { 'first_stage' : before => Stage['main'] }

node app-server {
  class { 'python_setuptools': stage => 'first_stage' }
  include tomcat
  include httpd
  if $bahmni_openerp_required == "true" {
    include openerp
  }
}

node db-server {
  include mysql_server
  if ($bahmni_openerp_required == "true") or ($bahmni_openelis_required == "true") {
    include postgresql
  }
}

node jasper-server {
  class { 'jasperserver' }
}

node nagios-server {
  $nagios_server_ip = $bahmni_nagios_server_ip ? { undef => "localhost", default => $bahmni_nagios_server_ip }
  include nagios_server
}

