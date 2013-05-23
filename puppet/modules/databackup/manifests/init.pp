class databackup {

  file { "${temp_dir}/pgsql_databackup.sh" :
    ensure      => present,
    content     => template("databackup/pgsql_databackup.sh.erb"),
    owner       => "${bahmni_user}",
    mode        => 544,
  }

  exec { "perform_postgresql_databackup" :
    command => "sh ${temp_dir}/pgsql_databackup.sh ${bahmni_user}",
    user    => "${bahmni_user}",
    path    => "${os_path}",
    require => File["${temp_dir}/pgsql_databackup.sh"]
  }
}