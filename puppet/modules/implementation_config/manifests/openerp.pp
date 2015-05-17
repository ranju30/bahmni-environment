class implementation_config::openerp inherits implementation_config::config {
  
 require implementation_config::setup
  
 implementation_config::migrations { "implementation_config_migrations_openerp":
    implementation_name => "${implementation_name}",
    app_name            => "openerp"
  }
}