class mysql {
	require yum-repo

	package { "mysql" :
		ensure  => present
	}
}

class mysqlserver {
	require yum-repo

	package { "mysql-server" :
		ensure  => present
	}

  file { "/etc/my.cnf" :
    ensure      => present,
    content     => template("mysql/my.cnf"),
    require     => Package["mysql-server"],
  }

	service { "mysqld" :
		ensure => running,
		enable => true,
		require => File["/etc/my.cnf"]
	}

 	exec { "setmysqlpassword" :
		command => "mysqladmin -u root PASSWORD ${mysqlRootPassword}; /bin/true",
		require => [Package["mysql-server"], Package["mysql"] , Service["mysqld"]],
		path => "${os_path}"
	}

	## Needed for Reporting database creation.. Mujir - move away from this file to a Reporting module
  file { "${temp_dir}/createReportingDB.sql" :
    ensure      => present,
    content     => template("mysql/createReportingDB.sql"),
    require     => Exec["setmysqlpassword"],
  }

	## Needed for Reporting database creation.. Mujir - move away from this file to a Reporting module
  exec { "createReportingDB" :
    command     => "mysql -uroot -p${mysqlRootPassword} < ${temp_dir}/createReportingDB.sql ${deployment_log_expression}",
    path        => "${os_path}",
    provider    => shell,
    require     => File["${temp_dir}/createReportingDB.sql"]
  }
}