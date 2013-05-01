class openerp {
  require python
  require postgresql

  $log_file = "${logs_dir}/openerp-module.log"
  $log_expression = ">> ${log_file} 2>> ${log_file}"

  file { "${log_file}" :
    ensure        => absent,
    purge         => true
  }

  notify { "Creating file ${temp_dir}/install_openerp.sh" :}

  file { "${temp_dir}/install_openerp.sh" :
      ensure      => present,
      content     => template("openerp/install_openerp.sh"),
      mode        => 544,
      require     => File["${log_file}"]
  }

  exec { "add-installation-script" :
      provider    => shell,
      command     => "sh --verbose ${temp_dir}/install_openerp.sh ${temp_dir} ${log_expression}",
      timeout     => 300,
      path        => "${os_path}",
      require     => File["${temp_dir}/install_openerp.sh"]
  }
}