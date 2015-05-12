class mysql_server {
	notice("mysqlserver manifest processing...")

    package { "MySQL-server" :
      ensure  => present
    }
    
    file { "/etc/my.cnf" :
      ensure      => present,
      content     => template("mysql_server/my.cnf"),
      require     => Package["MySQL-server"],
    }
    
    file { "/tmp/changepassword.sql" :
      ensure      => present,
      content     => template("mysql_server/changepassword.sql.erb"),
    }
    
    file { "/tmp/grantAccess.sql" :
      ensure      => present,
      content     => template("mysql_server/grantAccess.sql.erb"),
    }
    
    file { "/tmp/initdb.sh" :
      ensure      => present,
      content     => template("mysql_server/initdb.sh.erb"),
    }
    
    service { "mysql" :
      ensure => running,
      enable => true,
      require => File["/etc/my.cnf"],
    }
    
    exec {"changepassword" :
      command		=> "sh /tmp/initdb.sh ${mysqlRootPassword} ${deployment_log_expression}",
      provider  	=> shell,
      user      	=> "root",
      require 	=> [File["/tmp/changepassword.sql"], File["/tmp/grantAccess.sql"], File["/tmp/initdb.sh"], Service["mysql"]],
    }

}