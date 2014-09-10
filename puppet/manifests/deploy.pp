import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"
import "configurations/openmrs-versions-configuration.pp"

node default {
  include bahmni_openmrs
  include reference_data

  if $deploy_bahmni_openelis == "true" {
    include bahmni_openelis
  }

  if $deploy_bahmni_openerp == "true" {
    include bahmni_openerp
  }
}