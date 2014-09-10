import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"
import "configurations/openmrs-versions-configuration.pp"

# pre-condition
# bahmni-stop must have been run before this
node default {
  include bahmni-openmrs
  class { "implementation_config::openmrs":
    implementation_name => "${implementation_name}", require => Class['bahmni_omods'],
  }
}