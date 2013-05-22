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

    file { "${temp_dir}/${mysqlMachine}.sh" :
        ensure      => present,
        content     => template("mysql/${mysqlMachine}.sh"),
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
        command     => "sh ${temp_dir}/${machine}.sh",
        path        => "${os_path}",
        cwd         => "${temp_dir}",
        require     => [Package["mysql-server"], Package["mysql"] , Service["mysqld"], Exec["setmysqlpassword"], File['${temp_dir}/${mysqlMachine}.sh'],File['${temp_dir}/replicator.sh']]
    }
}