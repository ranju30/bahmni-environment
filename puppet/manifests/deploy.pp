import "configurations/stack-runtime-configuration"

node default {
	include openmrs
	include tomcat-runtime
	include openmrs-modules
}