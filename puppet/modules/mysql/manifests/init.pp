class mysql-common {
  
  include mysqlserver

	notice("mysql-common manifest processing...")
}

class mysql {
	#require yum_repo
	require mysql-common

	notice("mysql manifest processing...")

	package { "MySQL-client" :
		ensure  => present
	}
}

class mysqlserver {
	
	notice("mysqlserver manifest processing...")

	file { "/tmp/initdb.sh" :
		ensure      => present,
		content     => template("mysql/initdb.sh.erb"),
	}

	exec {"changepassword" : 
		command		=> "sh /tmp/initdb.sh ${mysqlRootPassword} ${deployment_log_expression}",
	    provider  	=> shell,
    	user      	=> "root",
    	require 	=> [File["/tmp/initdb.sh"]],
	}
}