class bahmni-openerp {
	file { "${bahmni_openerp_temp_dir}" :
    ensure    => directory,
    recurse   => true,
    force     => true,
    purge     => true
	}

	exec { "bahmni_openerp_codebase" :
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

	exec { "bahmni_openerp" :
		command => "cp -r ${bahmni_openerp_temp_dir}/* ${openerp_install_location}/openerp/addons ${deployment_log_expression}",
		path => "${os_path}",
		require => Exec["bahmni_openerp_codebase"]
	}
}