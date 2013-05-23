class jss-migration {
	$jss_data_temp = "${temp_dir}/jss-data"

	$jss_data_log_file = "${logs_dir}/jss-data.log"
	$jss_data_log_file_expression = ">> ${jss_data_log_file} 2>> ${jss_data_log_file}"

	file { "${jss_data_temp}" :
    ensure    => directory,
    recurse   => true,
    force     => true,
    purge     => true,
		mode 	    => 666
	}

	exec { "jss_data_migrator" :
		command => "unzip -q -o ${build_output_dir}/jss-old-data*.zip -d ${jss_data_temp} ${jss_data_log_file_expression}",
		path => "${os_path}",
		require => "${jss_data_temp}"
	}

	exec { "jss_data" :
		command => 'java -cp "jars/jss-old-data-0.2-SNAPSHOT.jar:jars/*" org.bahmni.jss.JSSMigrator ${package_dir}/data-dump/jss ${jss_data_log_file_expression}',
		path => "${os_path}",
		require => "${jss_data_migrator}",
		cwd			=> "${jss_data_temp}"
	}
}