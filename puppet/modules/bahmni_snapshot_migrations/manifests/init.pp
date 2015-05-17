class bahmni_snapshot_migrations inherits bahmni_snapshot_migrations::config {
  
  file { "${temp_dir}/create-openmrs-db-and-user.sql" :
    ensure      => present,
    content     => template("bahmni_snapshot_migrations/database.sql"),
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}"
  }
  
  exec { "openmrs_database" :
    command     => "mysql -h${db_server} -uroot -p${mysqlRootPassword} < ${temp_dir}/create-openmrs-db-and-user.sql   ${::config::deployment_log_expression}",
    path        => "${config::os_path}",
    provider    => shell,
    require     => File["${temp_dir}/create-openmrs-db-and-user.sql"]
  }

  file { "${temp_dir}/snapshots" :
    ensure => "directory",
    source => "puppet:///modules/bahmni_snapshot_migrations/snapshots",
    owner => "${::config::bahmni_user}",
    recurse => "true",
  }

  file { "${temp_dir}/liquibase-core-2.0.5.jar" :
    ensure => "directory",
    source => "puppet:///modules/bahmni_snapshot_migrations/liquibase-core-2.0.5.jar",
    owner => "${::config::bahmni_user}"
  }
  
  file { "${temp_dir}/run-snapshot-liquibase.sh" :
    ensure      => present,
    content     => template("bahmni_snapshot_migrations/run-snapshot-liquibase.sh"),
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
    mode        => 554,
    require => [File["${temp_dir}/snapshots"], File["${temp_dir}/liquibase-core-2.0.5.jar"]]
  }

  exec { "run-snapshot-migrations" :
    command     => "${temp_dir}/run-snapshot-liquibase.sh   ${::config::deployment_log_expression}",
    path        => "${config::os_path}",
    provider    => shell,
    require => [Exec["openmrs_database"], File["${temp_dir}/run-snapshot-liquibase.sh"]],
    timeout   => 0
  }
}