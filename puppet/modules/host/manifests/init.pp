class host {
	file { "${temp_dir}":
		ensure => "directory"
	}
}