class package-download {
  
	$package_download_temp = "${temp_dir}/package_download"

	file { "${package_download_temp}" :
		ensure 	=> directory,
		mode 	=> 666,
	    owner   => "${bahmni_user}",
	}

	file { "${package_download_temp}/getpackages.sh" :
		path    => "${package_download_temp}/getpackages.sh",
		ensure      => present,
		content     => template("package-download/getpackages.erb"),
		owner       => "${bahmni_user}",
		mode        => 544,
		require     => File["${package_download_temp}"]
	}

	exec { "get-packages-from-ci" :
		command		=> "sh getpackages.sh",
		user 		=> "${bahmni_user}",
		before	 	=> [Class["bahmni-webapps"], Class["openmrs"], Class["bahmni-data"], Class["Registration"]],
		path 			=> "${os_path}",
		cwd				=> "${package_download_temp}"
	}
}