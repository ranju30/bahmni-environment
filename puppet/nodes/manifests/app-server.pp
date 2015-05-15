class nodes::app-server{
  include tomcat
  include httpd
  if $bahmni_openerp_required == "true" {
    include openerp
  }
}