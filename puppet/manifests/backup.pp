import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"

# pre-condition
# bahmni-stop must have been run before this
node default {
	include bahmni-databackup
}