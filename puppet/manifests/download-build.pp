import "configurations/node-configuration"
import "configurations/openmrs-versions-configuration.pp"
import "configurations/stack-installers-configuration.pp"
import "configurations/stack-runtime-configuration.pp"

node default {
  include bahmni-artifacts
}