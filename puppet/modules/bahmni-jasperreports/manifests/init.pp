class bahmni-jasperreports {

	$properties_file = 'reports_default.properties'
	
	exec { "bahmni-jasperserver-deploy-reports" :
    provider => "shell",	
		command => "scripts/deploy.sh -j $jasperHome -p conf/${properties_file} ${deployment_log_expression}",
		path    => "${os_path}",
    	cwd     => "${build_output_dir}/jss-reports",
	}

	exec { "bahmni-jasperserver-deploy-customserver" :
    provider => "shell",	
		command => "scripts/deployCustomJasperServer.sh $jasperHome ${deployment_log_expression}",
		path    => "${os_path}",
    	cwd     => "${build_output_dir}/jss-reports",
	}
}