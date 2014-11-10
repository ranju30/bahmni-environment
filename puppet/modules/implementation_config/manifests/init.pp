class implementation_config {

  if $implementation_name == undef { fail("'implementation_name' not defined") }
  
  require implementation_config::setup
  
  contain 'implementation_config::openmrs'
  
  if $deploy_bahmni_openelis == "true" {
	  contain 'implementation_config::openelis'
  }
  
  if $deploy_bahmni_openerp == "true" {
	  contain 'implementation_config::openerp'
  }
}