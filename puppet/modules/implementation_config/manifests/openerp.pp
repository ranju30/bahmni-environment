class implementation_config::openerp($implementation_name = $implementation_name) {
  require implementation_config::setup
  
  $migrations_directory = "${build_output_dir}/${implementation_name}_config/openerp/migrations"

  file { "${temp_dir}/run-implementation-openerp-liquibase.sh" :
    ensure      => present,
    content     => template("implementation_config/run-implementation-openerp-liquibase.sh"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 554
  }

  exec { "run_openerp_implementation_liquibase_migration" :
    command     => "${temp_dir}/run-implementation-openerp-liquibase.sh  ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    cwd         => "${migrations_directory}",
    require     => File["${temp_dir}/run-implementation-openerp-liquibase.sh"],
    onlyif      => "test -f ${migrations_directory}/liquibase.xml"
  }
}