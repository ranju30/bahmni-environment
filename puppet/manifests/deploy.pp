import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"

node default {
	file { "${httpd_deploy_dir}" :
      ensure      => directory,
      owner       => "${bahmni_user}",
      group       => "${bahmni_user}",
      mode        => 644,
  }

  file { "${deployment_log_file}" :
    ensure    => absent
  }

  include ant
  include bahmni-stop
	include openmrs
	include bahmni-configuration
	include bahmni-webapps
	include bahmni-data
}