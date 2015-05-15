class bahmni::config inherits global {
  $bahmni_openelis_required = "${::global::bahmni_openelis_required}"
  $bahmni_openerp_required = "${::global::bahmni_openerp_required}"
}