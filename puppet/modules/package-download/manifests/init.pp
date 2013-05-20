class package-download {
  
	$bahmni_data_temp = "${temp_dir}/bahmni-data"

	file { "${bahmni_data_temp}" :
		ensure 	=> directory,
		mode 	=> 666,
	    owner   => "${bahmni_user}",
	}

	file { "${bahmni_data_temp}/getpackages.sh" :
		path    => "${bahmni_data_temp}/getpackages.sh",
		ensure      => present,
		content     => template("package-download/getpackages.erb"),
		owner       => "${bahmni_user}",
		mode        => 544,
		require     => File["${bahmni_data_temp}"]
	}

	exec { "get-packages-from-ci" :
		command		=> "sh getpackages.sh",
		user 		=> "${bahmni_user}",
		before	 	=> [Class["bahmni-webapps"], Class["openmrs"], Class["bahmni-data"], Class["Registration"]],
		path 			=> "${os_path}",
		cwd				=> "${bahmni_data_temp}"
	}
}