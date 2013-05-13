class postgresql {
	package { "postgresql92-libs" : ensure => installed}
	package { "postgresql92-server" : ensure => installed, require => Package["postgresql92-libs"]}
	package { "postgresql92" : ensure => installed, require => Package["postgresql92-server"]}

	exec { "postgresdb" :
		command => "service postgresql-9.2 initdb",
		path => "${os_path}",
		require => Package["postgresql92"]
	}

	exec { "postgres-server" :
		command => "chkconfig postgresql-9.2 on && service postgresql-9.2 start",
		path => "${os_path}",
		require => Exec["postgresdb"]
	}
	
	case $postgresMachine {
      master:{
          file {"/usr/local/pgsql/data/pg_hba.conf":
              content     => template("postgres/master_pg_hba.erb"),
              owner       => "${postgresUser}",
              group       => "${postgresUser}",
              mode        => 600,
              require     => Exec["backup_conf"],
          }

          file {"/usr/local/pgsql/data/postgresql.conf":
              content     => template("postgres/master_postgresql.erb"),
              owner       => "${postgresUser}",
              group       => "${postgresUser}",
              mode        => 600,
              require     => Exec["backup_conf"],
          }
      }

      slave:{
          file {"/usr/local/pgsql/data/pg_hba.conf":
              content     => template("postgres/slave_pg_hba.erb"),
              owner       => "${postgresUser}",
              group       => "${postgresUser}",
              mode        => 600,
              require     => Exec["backup_conf"],
          }

          file {"/usr/local/pgsql/data/postgresql.conf":
              content     => template("postgres/slave_postgresql.erb"),
              owner       => "${postgresUser}",
              group       => "${postgresUser}",
              mode        => 600,
              require     => Exec["backup_conf"],
          }
          
          file {"/usr/local/pgsql/data/recovery.conf":
              content     => template("postgres/slave_recovery.erb"),
              owner       => "${postgresUser}",
              group       => "${postgresUser}",
              mode        => 600,
          }
      }
  }
}