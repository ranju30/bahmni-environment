class bahmni-jasperreports {

	$properties_file = 'reports_default.properties'
	


	file { "delete_reports_dir" :
	    path      => "${build_output_dir}/${implementation}-reports",
	    ensure    => absent,
	    recurse   => true,
	    force     => true,
	    purge     => true,
	}

	# file { "delete_reports_zip" :
	#     path      => "${build_output_dir}/${implementation}-reports.zip",
	#     ensure    => absent,
	#     force     => true,
	# }

 #    exec { "download_reports_zip":
 #        command => "/usr/bin/wget --no-check-certificate ${report_zip_source_url} -O ${implementation}-reports.zip",
 #        cwd     => "${build_output_dir}",
 #        require => [File["delete_reports_dir"], File["delete_reports_zip"]],
 #    }

	exec { "unzip_report" :
	    command   => "unzip -q -o ${implementation}-reports.zip -d ${build_output_dir}/${implementation}-reports ${deployment_log_expression}",
	    provider  => shell,
	    path      => "${os_path}",
	    cwd       => "${build_output_dir}",
	    require   => File["delete_reports_dir"]
	  }

	exec { "bahmni-jasperserver-deploy-reports" :
    	provider => "shell",	
		command => "scripts/deploy.sh -j $jasperHome -p conf/${properties_file} ${deployment_log_expression}",
		path    => "${os_path}",
    	cwd     => "${build_output_dir}/${implementation}-reports/${implementation}-reports-master",
    	require => Exec["unzip_report"]
	}

	exec { "bahmni-jasperserver-deploy-customserver" :
    	provider => "shell",	
		command => "scripts/deployCustomJasperServer.sh $jasperHome ${deployment_log_expression}",
		path    => "${os_path}",
    	cwd     => "${build_output_dir}/${implementation}-reports/${implementation}-reports-master",
    	onlyif  => "test -f scripts/deployCustomJasperServer.sh",
    	require => Exec["bahmni-jasperserver-deploy-reports"]
	}
}