class bahmni_event_log_service {
  $bahmni_event_log_service_dir = "${build_output_dir}/bahmni-enviroment/puppet/modules/bahmni-event-log-service"
  $webapps_dir="${tomcatInstallationDirectory}/webapps"
  $liquibase_jar="${webapps_dir}/${bahmni_event_log_service_war_file_name}/WEB-INF/lib/liquibase-core-3.4.0.jar"
  $bahmni_event_log_service_war_path="${build_output_dir}/${bahmni_event_log_service_war_file_name}.war"
  $mysql_driver_path="${packages_servers_dir}/mysql-connector-java-${mysql_connector_java_version}.jar"

    exec { "clear_bahmni_event_log_service_webapp" :
        command   => "rm -rf ${tomcatInstallationDirectory}/webapps/${bahmni_event_log_service_war_file_name}",
        provider  => shell,
        path      => "${os_path}",
        user      => "${bahmni_user}"
    }

    exec { "latest_bahmni_event_log_service_webapp" :
	    command   => "unzip -o -q ${build_output_dir}/${bahmni_event_log_service_war_file_name}.war -d ${webapps_dir}/${bahmni_event_log_service_war_file_name} ${deployment_log_expression}",
	    provider  => shell,
	    path      => "${os_path}",
	    require   => [Exec["clear_bahmni_event_log_service_webapp"]],
	    user      => "${bahmni_user}"
	}

	file { "${temp_dir}/run-event-log-service-liquibase.sh" :
        ensure      => present,
        content     => template("bahmni_event_log_service/run-event-log-service-liquibase.sh"),
        owner       => "${bahmni_user}",
        group       => "${bahmni_user}",
        mode        => 554
      }

    if $is_passive_setup == "false" {
      exec { "run_bahmni_event_log_service_liquibase" :
        command     => "${temp_dir}/run-event-log-service-liquibase.sh ${deployment_log_expression}",
        path        => "${os_path}",
        provider    => shell,
        require     => [Exec["latest_bahmni_event_log_service_webapp"], File["${temp_dir}/run-event-log-service-liquibase.sh"]]
      }
    } else {
      notice ("Not running event_log_service migration. ")
    }
}