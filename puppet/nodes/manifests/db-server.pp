class nodes::db-server {
  include mysql_server
  if ($bahmni_openerp_required == "true") or ($bahmni_openelis_required == "true") {
    include postgresql
  }
}