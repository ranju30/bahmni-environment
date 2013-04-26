class host {
	file { "${temp_dir}":
		ensure => "directory"
	}

	file { "${package_dir}":
		ensure => "directory"
	}
}