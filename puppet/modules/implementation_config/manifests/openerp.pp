class implementation_config::openerp {
  implementation_config::migrations { "implementation_config_migrations_openerp":
    implementation_name => "${implementation_name}",
    app_name            => "openerp"
  }
}