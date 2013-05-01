class host {
	file { "${temp_dir}" :
		ensure 		=> directory,
		mode      => 777,
		recurse   => true
	}

	file { "${temp_dir}/logs" :
		ensure 		=> directory,
    mode      => 666,
    recurse   => true,
    require		=> File["${temp_dir}"]	
	}

	file { "${package_dir}" :
		ensure 		=> directory,
		mode      => 555,
		recurse   => true,
	}
}