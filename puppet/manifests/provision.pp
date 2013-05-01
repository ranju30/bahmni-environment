import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"

node default {
	include host
	include tools
	include java

  import "subsystems/openmrs"
  import "subsystems/jasperreports"

  include tomcat-runtime
}