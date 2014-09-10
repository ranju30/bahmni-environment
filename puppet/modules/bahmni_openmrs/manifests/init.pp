class bahmni_openmrs {
	include bahmni_omods
	include bahmni-ui-apps 
	include bahmni-revisions
	class { "implementation_config::openmrs":
	    implementation_name => "${implementation_name}", require => Class['bahmni_omods']
	}
}