class bahmni {

  require bahmni_openmrs
  require reference_data
  require bahmni_client_side_logging
  
  if $deploy_bahmni_openelis == "true" {
    require bahmni_openelis
  }
  
  if $deploy_bahmni_openerp == "true" {
    require bahmni_openerp
  }
  
}