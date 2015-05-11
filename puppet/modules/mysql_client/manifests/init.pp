class mysql_client {

  package { "MySQL-client" :
    ensure  => present
  }
  notice("mysql-client manifest processing...")
}
