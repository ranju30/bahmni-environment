import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"

node default {
	Exec {
  	path => "${os_path}"
	}

	include host
	include tools
	include java

  import "subsystems/openmrs"
}