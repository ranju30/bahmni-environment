class bahmni_openmrs {
	include bahmni_omods
	include bahmni_ui_apps 
	include bahmni_revisions
	class { "implementation_config::openmrs":
	    implementation_name => "${implementation_name}", require => Class['bahmni_omods']
	}
}