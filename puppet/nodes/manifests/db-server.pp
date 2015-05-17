class nodes::db-server inherits global {
  include mysql_server
  if ("${::global::bahmni_openerp_required}" == "true") or ("${::global::bahmni_openelis_required}" == "true") {
    include postgresql
  }
}