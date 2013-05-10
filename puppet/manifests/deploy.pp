import "configurations/stack-runtime-configuration"

node default {
	file { "${deployDirectory}" :
      ensure      => directory,
      owner       => "${bahmni_user}",
      group       => "${bahmni_user}",
      mode        => 644,
  }

  include openmrs
  # include tomcat-runtime
	# include openmrs-modules
  # include bahmni
  # include registration
}