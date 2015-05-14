class nodes::app-server{
  include tomcat
  include httpd
  if $bahmni_openerp_required == "true" {
    include openerp
  }
}


puppet
  nodes
    config
    app
      config
    db
      config

  modules
    provision
    deploy