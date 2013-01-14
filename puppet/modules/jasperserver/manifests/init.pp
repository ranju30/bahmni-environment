class jasperserver () {

    exec {"get_jasperserver":
        command     => "/usr/bin/wget -O /tmp/jasperserver-4.7.0.zip http://nchc.dl.sourceforge.net/project/jasperserver/JasperServer/JasperReports%20Server%204.7.0/jasperreports-server-cp-4.7.0-bin.zip",
        timeout     => 0,
        provider    => "shell",
        user        => "${jssUser}",
        onlyif      => "test ! -f /tmp/jasperserver-4.7.0.zip"
    }
	
    file { "remove_temp_jasperserver_dir":
        ensure      => "absent",
		path		=> "/tmp/jasperserver",
        purge       => true,
    }
	
	file { "java_home_path": 
        path 		=> "/etc/profile.d/java.sh",
        ensure 		=> "present",
        content 	=> template ("jasperserver/java.sh"),
        owner 		=> 'root',
        group 		=> 'root',
        mode 		=> '644',		
	}	
	
    exec {"copy_mysql_jar" : 
       command         => "cp /usr/share/java/mysql-connector-java.jar ${jasperHome}/buildomatic/conf_source/db/mysql/jdbc",
       user            => "${jssUser}",
       }

    file { "${jasperHome}":
        ensure      => "directory",
        purge       => true,
        owner       => "${jssUser}",
        group       => "${jssUser}"
    }

    exec { "unzip_jasperserver":
        command     => "jar xvf /tmp/jasperserver-4.7.0.zip && cp -r ./jasperreports-server-cp-4.7.0-bin/* ./ && rm -rf ./jasperreports-server-cp-4.7.0-bin/",
        cwd         => "${jasperHome}",
        require     => [File["${jasperHome}"], Exec["get_jasperserver"]],
        provider    => "shell",
        user        => "${jssUser}"
    }

    file { "${jasperHome}/buildomatic/default_master.properties":
        content     => template("jasperserver/default_master.properties.erb"),
        require     => Exec['unzip_jasperserver'],
        owner       => "${jssUser}",
        group       => "${jssUser}"
    }

    file { "${jasperHome}/buildomatic/bin/do-js-setup.sh":
        content     => template("jasperserver/do-js-setup.sh"),
        require     => Exec['unzip_jasperserver'],
        owner       => "${jssUser}",
        group       => "${jssUser}"
    }

    exec { "set_jasperserver_scripts_permission":
        command     => "find . -name '*.sh' | xargs chmod u+x",
        user        => "${jssUser}",
        require     => [File["${jasperHome}/buildomatic/bin/do-js-setup.sh"], File["${jasperHome}/buildomatic/default_master.properties"], File["remove_temp_jasperserver_dir"]],
        cwd         => "${jasperHome}"
    }
	
    exec { "set_jasperserver_ant_permission":
        command     => "chmod u+x ${jasperHome}/apache-ant/bin/ant",
        user        => "${jssUser}",
        require     => [File["${jasperHome}/buildomatic/bin/do-js-setup.sh"], File["${jasperHome}/buildomatic/default_master.properties"], File["remove_temp_jasperserver_dir"]],
        cwd         => "${jasperHome}"
    }

    exec { "make_jasperserver":
        command     => "echo '$jasperResetDb' | /bin/sh js-install-ce.sh minimal",
        require     => [Exec["set_jasperserver_scripts_permission"],File["java_home_path"], Exec["copy_mysql_jar"],Exec["set_jasperserver_ant_permission"]],
        cwd         => "${jasperHome}/buildomatic",
        user        => "${jssUser}"
    }

    file { "/tmp/configure_jasper_home.sh" :
         require => Exec["make_jasperserver"],
         content => template("jasperserver/configure_jasper_home.sh"),
         owner => "${jssUser}",
         group => "${jssUser}",
         mode   =>  764
    }

    exec { "config-jasper-home" :
        require => File["/tmp/configure_jasper_home.sh"],
        command => "sh /tmp/configure_jasper_home.sh ${jasperHome} ${jssUser}",
        user        => "${jssUser}"
    }
	
	exec {"restart_tomcat" :
	        command     => "/home/${jssUser}/apache-tomcat-7.0.22/bin/shutdown.sh && /home/jss/apache-tomcat-7.0.22/bin/startup.sh",
	        user        => "${jssUser}",
			require		=> Exec["make_jasperserver"],
	}
}
