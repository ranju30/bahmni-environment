import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"
import "configurations/openmrs-versions-configuration.pp"

# pre-condition
# bahmni-stop must have been run before this
node default {

  warning "This manifest 'deploy-jss-bahmni-openmrs' is deprecated. Instead consider using 'deploy-impl-bahmni-openmrs'"

  include bahmni-openmrs
  class { 'implementation-config':
    implementationName => "jss", require => Class['bahmni-webapps'],
  }
}