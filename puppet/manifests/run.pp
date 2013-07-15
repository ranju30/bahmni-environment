import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"

# To run this:
# export FACTER_module_name="bahmni-data"
# puppet apply puppet/manifests/run.pp  --modulepath=puppet/modules/
node default {
	include $module_name
}