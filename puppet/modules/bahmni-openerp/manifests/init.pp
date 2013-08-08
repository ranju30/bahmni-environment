class bahmni-openerp {
    $log4j_xml_file = "${tomcatInstallationDirectory}/webapps/${openerp_atomfeed_war_file_name}/WEB-INF/classes/log4j.xml"


	file { "${bahmni_openerp_temp_dir}" :
    ensure    => absent,
    force     => true
	}

	exec { "bahmni_openerp_codebase" :
    provider => "shell",	
		command => "git clone https://github.com/Bhamni/openerp-modules.git ${bahmni_openerp_temp_dir} ${deployment_log_expression}",
		path => "${os_path}",
		require => File["${bahmni_openerp_temp_dir}"]
	}

	# exec { "bahmni_openerp_codebase_version" :
	# 	command => "git checkout --track -b ${bahmni_openerp_branch} remotes/origin/${bahmni_openerp_branch} ${deployment_log_expression}",
	# 	path => "${os_path}",
	# 	cwd => "${bahmni_openerp_temp_dir}",
	# 	require => Exec["bahmni_openerp_codebase"]
	# }

    ## Mujir/Sush - Using puppet's {recurse => true} takes > 13 hours to complete!!!!!!
	exec { "change_group_rights_for_openerp_temp_folders_current_content" :
	  provider => "shell",
		command => "chown -R openerp:openerp $bahmni_openerp_temp_dir; chmod -R 775 $bahmni_openerp_temp_dir; ",
		path => "${os_path}",
		require => Exec["bahmni_openerp_codebase"],
	}
	
	exec { "change_group_rights_for_openerp_folders_current_content" :
	  provider => "shell",
		command => "chown -R openerp:openerp $openerp_install_location; chmod -R 775 $openerp_install_location; ",
		path => "${os_path}",
		require => Exec["change_group_rights_for_openerp_temp_folders_current_content"],
	}
	
	exec { "bahmni_openerp" :
	  provider => "shell",
		command => "cp -r ${bahmni_openerp_temp_dir}/* ${openerp_install_location}/openerp/addons ${deployment_log_expression}",
		path => "${os_path}",
		user => "${openerpShellUser}",
		group => "${openerpGroup}",
		require => Exec["change_group_rights_for_openerp_folders_current_content"],
	}

  exec { "latest_openerp_atomfeed_webapp" :
    command   => "unzip -o -q ${build_output_dir}/${openerp_atomfeed_war_file_name}.war -d ${tomcatInstallationDirectory}/webapps/openerp-atomfeed-service ${deployment_log_expression}",
    provider  => shell,
    path      => "${os_path}",
    require   => [Exec["bahmni_openerp"]],
    user      => "${bahmni_user}"
  }

  file { "${temp_dir}/bahmni-openerp/run-liquibase.sh" :
    ensure      => present,
    content     => template("bahmni-openerp/run-liquibase.sh"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    require   => Exec["latest_openerp_atomfeed_webapp"],
    mode        => 554
  }

  exec { "bahmni_openerp_data" :
    command     => "${temp_dir}/bahmni-openerp/run-liquibase.sh ${build_output_dir} ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    cwd         => "${tomcatInstallationDirectory}/webapps",
    require     => [File["${temp_dir}/bahmni-openerp/run-liquibase.sh"]]
  }

  file { "${log4j_xml_file}" :
    ensure      => present,
    content     => template("bahmni-openerp/log4j.xml.erb"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    require     => Exec["latest_openerp_atomfeed_webapp"],
    mode        => 664,
  }

}