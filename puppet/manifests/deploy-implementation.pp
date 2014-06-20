import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"
import "configurations/openmrs-versions-configuration.pp"

node default {
  include bahmni-configuration
  include httpd
  include bahmni-webapps
  include bahmni-ui-apps
  include bahmni-openerp
  class { 'implementation-config':
    implementationName => "${implementation}", require => [ Class['bahmni-webapps'], Class['openelis'], Class['bahmni-openerp']],
  }
  include openelis
  include reference-data
}