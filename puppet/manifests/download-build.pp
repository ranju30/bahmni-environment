import "configurations/node-configuration"
import "configurations/openmrs-versions-configuration.pp"

node default {
  include bahmni-artifacts
}