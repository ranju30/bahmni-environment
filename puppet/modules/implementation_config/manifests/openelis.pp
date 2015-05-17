class implementation_config::openelis inherits implementation_config::config {
  
  require implementation_config::setup

  exec { "copyLogoToOpenelis" :
    command   => "cp ${::config::build_output_dir}/${implementation_name}_config/openelis/images/labLogo.jpg ${::config::webapps_dir}/${openelis_war_file_name}/WEB-INF/reports/images",
    provider  => shell,
    path      => "${config::os_path}",
    onlyif    => "test -f ${::config::build_output_dir}/${implementation_name}_config/openelis/images/labLogo.jpg"
  }

  exec { "copyLogoToOpenelisForReportConfig" :
    command   => "cp ${::config::build_output_dir}/${implementation_name}_config/openelis/images/labLogo.jpg ${::config::webapps_dir}/${openelis_war_file_name}/images",
    provider  => shell,
    path      => "${config::os_path}",
    onlyif    => "test -f ${::config::build_output_dir}/${implementation_name}_config/openelis/images/labLogo.jpg"
  }
  
  file { "${::config::build_output_dir}/OpenElis.zip" : ensure => absent, purge => true}

  exec { "bahmni_openelis_codebase_for_liquibase_jar" :
    provider => "shell",
    command  => "unzip -o -q ${::config::build_output_dir}/OpenElis.zip -d ${temp_dir}   ${::config::deployment_log_expression}",
    path     => "${config::os_path}",
    onlyif    => "test -f ${::config::build_output_dir}/${implementation_name}_config/migrations/openelis/liquibase.xml",
    require   => [File["${::config::build_output_dir}/OpenElis.zip"]]
  }

  if $is_passive_setup == "false" {
    implementation_config::migrations { "implementation_config_migrations_openelis":
    implementation_name => "${implementation_name}",
    app_name            => "openelis"
    }
  }

}