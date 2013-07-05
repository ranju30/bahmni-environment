class bahmni-openerp {
	require openerp

	file { "${bahmni_openerp_temp_dir}" :
    ensure    => directory,
    owner	  => "${openerpShellUser}",
    recurse   => true,
    force     => true,
    purge     => true
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
}
