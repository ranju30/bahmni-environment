class pacs {
  $bahmni_pacs_temp_dir = "${temp_dir}/PACS"

  file { "${temp_dir}/create-pacs-db-and-user.sql" :
    ensure      => present,
    content     => template("bahmni_snapshot_migrations/database.sql"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}"
  }

  exec { "pacs_database" :
    command     => "psql -Upostgres < ${temp_dir}/create-pacs-db-and-user.sql ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    require     => File["${temp_dir}/create-pacs-db-and-user.sql"]
  }
}
