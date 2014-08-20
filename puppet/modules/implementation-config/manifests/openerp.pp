class implementation-config::openerp($implementation_name = $implementation_name) {
  require implementation-config::setup
  
  $openerp_migrations_directory = "${build_output_dir}/${implementation_name}_config/openerp/migrations"

  file { "${temp_dir}/run-implementation-openerp-liquibase.sh" :
    ensure      => present,
    content     => template("implementation-config/run-implementation-openerp-liquibase.sh"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 554
  }

  exec { "run_openerp_implementation_liquibase_migration" :
    command     => "${temp_dir}/run-implementation-openerp-liquibase.sh  ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    cwd         => "${openerp_migrations_directory}",
    require     => File["${temp_dir}/run-implementation-openerp-liquibase.sh"],
    onlyif      => "test -f ${openerp_migrations_directory}/liquibase.xml"
  }
}