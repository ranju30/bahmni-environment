import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"
import "configurations/openmrs-versions-configuration.pp"

node default {
  stage {"last" :}
  Stage ['main'] -> Stage['last']

  include bahmni-openmrs
  include bahmni-openerp
  include openelis
  include reference-data

  class { 'implementation_config':
    implementation_name => "${implementation_name}",
    stage =>'last'
  }
}