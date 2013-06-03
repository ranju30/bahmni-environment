class bahmni-databackup {
  $backup_hour = 22;

  file { "${temp_dir}/mysql_databackup.sh" :
    ensure      => present,
    content     => template("bahmni-databackup/mysql_databackup.sh.erb"),
    owner       => "${bahmni_user}",
    mode        => 544,
  }

  cron { "backup_mysql" :
      command => "sh ${temp_dir}/mysql_databackup.sh ",
      user    => "root",
      hour  => $backup_hour,
      require => File["${temp_dir}/mysql_databackup.sh"]
  }
  
  file { "${temp_dir}/pgsql_databackup.sh" :
    ensure      => present,
    content     => template("bahmni-databackup/pgsql_databackup.sh.erb"),
    owner       => "${bahmni_user}",
    mode        => 544,
  }
  
  cron { "backup_postgres" :
       command => "sh ${temp_dir}/pgsql_databackup.sh ${bahmni_user}",
       user    => "root",
       hour  => $backup_hour,
       require => File["${temp_dir}/pgsql_databackup.sh"]
   }
}