class mysql_client {
  notice("mysql-common manifest processing...")

  package { "MySQL-shared-compat" :
    ensure  => present
  }

  package { "MySQL-shared" :
    ensure  => present
  }

  package { "MySQL-client" :
    ensure  => present
  }
  notice("mysql-client manifest processing...")
}
