class implementation_config inherits implementation_config::config {

  if $implementation_name == undef { fail("'implementation_name' not defined") }
  
  contain 'implementation_config::openmrs'
  
  if "${::config::bahmni_openelis_required}" == "true" {
	  contain 'implementation_config::openelis'
  }

  if "${::config::bahmni_openerp_required}" == "true" {
	  contain 'implementation_config::openerp'
  }
}