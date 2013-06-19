class bahmni-databackup {
  file { "${backup_dir}" :
    ensure => directory,
    mode  => 666
  }

  file { "${temp_dir}/mysql_databackup.sh" :
    ensure      => present,
    content     => template("bahmni-databackup/mysql_databackup.sh.erb"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 554,
  }

  cron { "backup_mysql" :
      command => "sh ${temp_dir}/mysql_databackup.sh 2>&1 >>${logs_dir}/backup_mysql.log",
      user    => "root",
      hour  => $backup_hour,
      require => File["${temp_dir}/mysql_databackup.sh", "${backup_dir}"]
  }
  
  file { "${temp_dir}/pgsql_databackup.sh" :
    ensure      => present,
    content     => template("bahmni-databackup/pgsql_databackup.sh.erb"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 554,
  }
  
  cron { "backup_postgres" :
       command => "sh ${temp_dir}/pgsql_databackup.sh 2>&1 >>${logs_dir}/backup_postgres.log",
       user    => "root",
       hour  => $backup_hour,
       require => File["${temp_dir}/pgsql_databackup.sh", "${backup_dir}"]
   }
   
   # Image replication + backup happens in jss-cron module
}