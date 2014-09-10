class bahmni_openelis {
	require openelis

	class { "implementation_config::openelis":
		implementation_name => "${implementation_name}", require => Exec['openelis_setupdb']
	}
}