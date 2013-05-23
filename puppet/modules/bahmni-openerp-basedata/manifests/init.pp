class bahmni-openerp-basedata {
	$log_file = "${logs_dir}/bahmni-openerp-basedata.log"
  $log_expression = ">> ${log_file} 2>> ${log_file}"

	file { "${temp_dir}/create-database.sh" :
    path    		=> "${temp_dir}/create-database.sh",
    content     => template("bahmni-openerp-basedata/create-database.sh"),
	  ensure      => present,
	  mode        => 544
	}

	exec { "openerp_database" :
    provider    => shell,
    command     => "sh create-database.sh ${log_expression}",
    path        => "${os_path}",
    cwd         => "${temp_dir}",
    require			=> File["${temp_dir}/create-database.sh"]
	}

	exec { "openerp_base_data" :
		command => "psql openerp < ${package_dir}/data-dump/${openerp_base_data_dump} ${log_expression}",
		user    => "postgres",
		path 		=> "${os_path}",
		require	=> Exec["openerp_database"]
	}
}