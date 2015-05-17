class nodes::app-server inherits global {
  include tomcat
  include httpd
  if "${::global::bahmni_openerp_required}" == "true" {
    include openerp
  }
}