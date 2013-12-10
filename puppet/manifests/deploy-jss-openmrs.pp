import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"
import "configurations/openmrs-versions-configuration.pp"

# pre-condition
# bahmni-stop must have been run before this
node default {
	include bahmni-configuration
	include bahmni-webapps
	  class {'implementation-config':
          implementationName => "jss",
          require           => [Class["openmrs"],Class["bahmni-webapps"]]
        }
 	include bahmni-ui-apps
}