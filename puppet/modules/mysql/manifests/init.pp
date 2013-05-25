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
}

class mysqlreplication{
    require mysql
    require mysqlserver

    file { "${temp_dir}/replicate.sh" :
        ensure      => present,
        content     => template("mysql/${mysqlMachine}.sh.erb"),
        owner       => "${bahmni_user}",
        mode        => 544
    }

    file { "${temp_dir}/replicator.sh" :
        ensure      => present,
        content     => template("mysql/replicator.sh"),
        owner       => "${bahmni_user}",
        mode        => 544
    }

    exec { "run-mysql-replication-scripts" :
        command     => "sh ${temp_dir}/replicate.sh",
        path        => "${os_path}",
        cwd         => "${temp_dir}",
        require     => [File["${temp_dir}/replicate.sh"],File["${temp_dir}/replicator.sh"],Service["mysqld"]]
    }
}