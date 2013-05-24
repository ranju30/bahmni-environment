class mysql-databackup {

  file { "${temp_dir}/mysql_databackup.sh" :
    ensure      => present,
    content     => template("mysql-databackup/mysql_databackup.sh.erb"),
    owner       => "${bahmni_user}",
    mode        => 544,
  }

  exec { "perform_mysql_databackup" :
    command => "sh ${temp_dir}/mysql_databackup.sh",
    user    => "${bahmni_user}",
    path    => "${os_path}",
    require => File["${temp_dir}/mysql_databackup.sh"]
  }

}