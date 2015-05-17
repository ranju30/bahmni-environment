class bahmni inherits bahmni::config {

  require bahmni_openmrs
  require bahmni_client_side_logging
  
  if "${::config::bahmni_openelis_required}" == "true" {
    require bahmni_openelis
  }
  
  if "${::config::bahmni_openerp_required}" == "true" {
    require bahmni_openerp
  }
  
}