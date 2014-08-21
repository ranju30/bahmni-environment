class implementation_config::openelis($implementation_name = $implementation_name) {
  require implementation_config::setup
  $migrations_directory = "${build_output_dir}/${implementation_name}_config/migrations"

  exec { "copyLogoToOpenelis" :
    command   => "cp ${build_output_dir}/${implementation_name}_config/openelis/images/labLogo.jpg ${tomcatInstallationDirectory}/webapps/${openelis_war_file_name}/WEB-INF/reports/images",
    provider  => shell,
    path      => "${os_path}",
    onlyif    => "test -f ${build_output_dir}/${implementation_name}_config/openelis/images/labLogo.jpg"
  }

  exec { "copyLogoToOpenelisForReportConfig" :
    command   => "cp ${build_output_dir}/${implementation_name}_config/openelis/images/labLogo.jpg ${tomcatInstallationDirectory}/webapps/${openelis_war_file_name}/images",
    provider  => shell,
    path      => "${os_path}",
    onlyif    => "test -f ${build_output_dir}/${implementation_name}_config/openelis/images/labLogo.jpg"
  }
  
  exec { "bahmni_openelis_codebase_for_liquibase_jar" :
    provider => "shell",
    command  => "rm -rf ${bahmni_openelis_temp_dir} && unzip -o -q ${build_output_dir}/OpenElis.zip -d ${temp_dir} ${deployment_log_expression}",
    path     => "${os_path}",
    onlyif    => "test -f ${build_output_dir}/${implementation_name}_config/migrations/openelis/liquibase.xml"
  }

  file { "${temp_dir}/run-implementation-openelis-config-liquibase.sh" :
    ensure      => present,
    content     => template("implementation_config/run-implementation-openelis-config-liquibase.sh"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 554
  }

  exec { "run_implementation_openelis_config_liquibase_migration" :
    command     => "${temp_dir}/run-implementation-openelis-config-liquibase.sh  ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    cwd         => "${migrations_directory}",
    require     => [File["${temp_dir}/run-implementation-openelis-config-liquibase.sh"],Exec["bahmni_openelis_codebase_for_liquibase_jar"]],
    onlyif    => "test -f ${build_output_dir}/${implementation_name}_config/migrations/openelis/liquibase.xml"
  }
}