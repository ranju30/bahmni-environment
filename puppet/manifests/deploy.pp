import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"
import "configurations/openmrs-versions-configuration.pp"

# pre-condition
# bahmni-stop must have been run before this
node default {
  include openmrs
  include bahmni-configuration
  include bahmni-webapps
  class { bahmni-data: require => Class["bahmni-webapps"] }
  include bahmni-ui-apps
  include bahmni-openerp
  include openelis
}