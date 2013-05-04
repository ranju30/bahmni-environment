class openerp {
  require python-platform
  require postgresql

  $openerp_temp = "${temp_dir}/openerp"
  $log_file = "${logs_dir}/openerp-module.log"
  $log_expression = ">> ${log_file} 2>> ${log_file}"

  file { "${log_file}" : ensure => absent, purge => true}
  file { "${openerp_temp}" : ensure => directory, mode => 744}

  notify { "Creating file ${openerp_temp}/install_openerp.sh" :}

  file { "${openerp_temp}/install_openerp.sh" :
    ensure      => present,
    content     => template("openerp/install_openerp.erb"),
    mode        => 544,
    require     => [File["${log_file}"], File["${openerp_temp}"]]
  }

  exec { "openerp_installed" :
    provider    => shell,
    command     => "sh install_openerp.sh ${package_dir} ${openerp_installer_file} ${log_expression}",
    timeout     => 300,
    path        => "${os_path}",
    require     => File["${openerp_temp}/install_openerp.sh"],
    cwd         => "${openerp_temp}"
  }
}