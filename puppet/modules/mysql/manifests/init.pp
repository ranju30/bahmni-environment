class mysql {
	require host

	package { "mysql" :
		ensure  => present
	}
}

class mysqlserver {
	require host

	package { "mysql-server" :
		ensure  => present
	}

	service { "mysqld" :
		ensure => running,
		enable => true,
		require => Package["mysql-server"]
	}

 	exec { "setmysqlpassword" :
		command => "mysqladmin -u root PASSWORD ${mysqlRootPassword}; /bin/true",
		require => [Package["mysql-server"], Package["mysql"] , Service["mysqld"]],
		path => "${os_path}"
	}
	
	package { "mysql-connector-java" :
		ensure => "present"
	}
}