import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"

# pre-condition
# bahmni-stop must have been run before this
node default {
	file { "${httpd_deploy_dir}" :
      ensure      => directory,
      owner       => "${bahmni_user}",
      group       => "${bahmni_user}",
      mode        => 644,
  }

  file { "${deployment_log_file}" :
      ensure      => present,
      owner       => "${bahmni_user}",
      group       => "${bahmni_user}",
      mode        => 666,
      content     => "",
  }

  include package-download
	include openmrs
	include bahmni-configuration
	include bahmni-webapps
  include ant
	include bahmni-data
  include bahmni-openerp
  include registration
}