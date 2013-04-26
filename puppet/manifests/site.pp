node default {
  import "configurations/stack-installers-configuration"
  import "configurations/stack-runtime-configuration"
  import "configurations/node-configuration"

	Exec {
  	path => "${os_path}"
	}

	include host
	include tools
	include java
}