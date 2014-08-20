class bahmni-snapshot-migrations() {
  file { "${temp_dir}/snapshots" :
    ensure => "directory",
    source => "puppet:///modules/bahmni-snapshot-migrations/snapshots",
    owner => "${bahmni_user}",
    recurse => "true",
  }

  file { "${temp_dir}/run-snapshot-liquibase.sh" :
    ensure      => present,
    content     => template("bahmni-snapshot-migrations/run-snapshot-liquibase.sh"),
    owner       => "${bahmni_user}",
    group       => "${bahmni_user}",
    mode        => 554,
    require => File["${temp_dir}/snapshots"]
  }

  exec { "run-snapshot-migrations" :
    command     => "${temp_dir}/run-snapshot-liquibase.sh ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    require => File["${temp_dir}/run-snapshot-liquibase.sh"],
    timeout   => 0
  }
}