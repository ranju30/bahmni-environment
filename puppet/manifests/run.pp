import "configurations/stack-installers-configuration"
import "configurations/runtime/*"
import "configurations/constants"

# To run this:
# export FACTER_module_name="bahmni-data"
# puppet apply puppet/manifests/run.pp  --modulepath=puppet/modules/
node default {
  notice "Running $module_to_run"
	include $module_to_run
}