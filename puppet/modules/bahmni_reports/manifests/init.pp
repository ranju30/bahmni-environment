class bahmni_reports inherits bahmni_reports::config {
  $bahmni_reports_dir = "${::config::build_output_dir}/bahmni-enviroment/puppet/modules/bahmni_reports"
  $liquibase_jar="${::config::webapps_dir}/openmrs/WEB-INF/lib/liquibase-core-2.0.5.jar"
  $bahmni_reports_war_path="${::config::build_output_dir}/${bahmni_reports_war_file_name}.war"
  $mysql_driver_path="${packages_servers_dir}/mysql-connector-java-${mysql_connector_java_version}.jar"

	exec { "clear_bahmni_reports_webapp" :
	    command   => "rm -rf ${::config::webapps_dir}/${bahmni_reports_war_file_name}",
	    provider  => shell,
	    path      => "${config::os_path}",
	    user      => "${::config::bahmni_user}"
	}

    exec { "latest_bahmni_reports_webapp" :
	    command   => "unzip -o -q ${::config::build_output_dir}/${bahmni_reports_war_file_name}.war -d ${::config::webapps_dir}/${bahmni_reports_war_file_name}   ${::config::deployment_log_expression}",
	    provider  => shell,
	    path      => "${config::os_path}",
	    require   => [Exec["clear_bahmni_reports_webapp"]],
	    user      => "${::config::bahmni_user}"
	}

	file { "${temp_dir}/run-bahmni-reports-liquibase.sh" :
        ensure      => present,
        content     => template("bahmni_reports/run-bahmni-reports-liquibase.sh"),
        owner       => "${::config::bahmni_user}",
        group       => "${::config::bahmni_user}",
        mode        => 554
      }

    if $is_passive_setup == "false" {
      exec { "run_bahmni_reports_liquibase" :
        command     => "${temp_dir}/run-bahmni-reports-liquibase.sh   ${::config::deployment_log_expression}",
        path        => "${config::os_path}",
        provider    => shell,
        require     => [Exec["latest_bahmni_reports_webapp"], File["${temp_dir}/run-bahmni-reports-liquibase.sh"]]
      }
    } else {
      notice ("Not running reports migration. ")
    }
}