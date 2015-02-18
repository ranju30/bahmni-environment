class bahmni {

  require bahmni_openmrs
  require reference_data
  require bahmni_client_side_logging
  
  if $bahmni_openelis_required == "true" {
    require bahmni_openelis
  }
  
  if $bahmni_openerp_required == "true" {
    require bahmni_openerp
  }
  
}