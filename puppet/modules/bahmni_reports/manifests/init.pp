class bahmni_reports {
	exec { "clear_bahmni_reports_webapp" :
	    command   => "rm -rf ${tomcatInstallationDirectory}/webapps/${bahmni_reports_war_file_name}",
	    provider  => shell,
	    path      => "${os_path}",
	    user      => "${bahmni_user}"
	}

    exec { "latest_bahmni_reports_webapp" :
	    command   => "unzip -o -q ${build_output_dir}/${bahmni_reports_war_file_name}.war -d ${tomcatInstallationDirectory}/webapps/${bahmni_reports_war_file_name} ${deployment_log_expression}",
	    provider  => shell,
	    path      => "${os_path}",
	    require   => [Exec["clear_bahmni_reports_webapp"]],
	    user      => "${bahmni_user}"
	}
}