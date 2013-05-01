class host {
	file { "${temp_dir}" :
		ensure 		=> directory,
		mode      => 555
	}

	file { "${temp_dir}/logs" :
		ensure 		=> directory,
    mode      => 555
	}

	file { "${package_dir}" :
		ensure 		=> directory,
		mode      => 555
	}
}