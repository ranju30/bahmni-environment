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
}