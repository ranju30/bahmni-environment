class bahmni_openerp_basedata inherits bahmni_openerp_basedata::config {
  
	$log_file = "${logs_dir}/bahmni_openerp_basedata.log"
  $log_expression = ">> ${log_file} 2>> ${log_file}"

	file { "${temp_dir}/create-database.sh" :
    path    		=> "${temp_dir}/create-database.sh",
    content     => template("bahmni_openerp_basedata/create-database.sh"),
	  ensure      => present,
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
	  mode        => 554
	}

	exec { "openerp_database" :
    provider    => shell,
    command     => "sh create-database.sh ${log_expression}",
    path        => "${config::os_path}",
    cwd         => "${temp_dir}",
    require			=> File["${temp_dir}/create-database.sh"]
	}

  exec { "openerp_base_data_for_ci" :
    command => "psql -U openerp openerp < ${packages_servers_dir}/bahmni-openerp-base-data.sql",
    user    => "postgres",
    path    => "${config::os_path}",
    require => Exec["openerp_database"]
  }  
}