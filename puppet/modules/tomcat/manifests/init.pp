class tomcat ( $version, $userName, $tomcatManagerUserName = "tomcat", $tomcatManagerPassword, $tomcatHttpPort = "8080", $tomcatRedirectPort = "8443", $tomcatShutdownPort = "8005", $tomcatAjpPort = "8009", $tomcatInstallationDirectory) {

    exec {"gettomcattarfile" :
        command     => "/usr/bin/wget -O /tmp/apache-tomcat-${version}.tar.gz http://archive.apache.org/dist/tomcat/tomcat-7/v${version}/bin/apache-tomcat-${version}.tar.gz",
        require     => [User["${userName}"]],
        timeout     => 0,
        provider    => "shell",
        onlyif      => "test ! -f /tmp/apache-tomcat-${version}.tar.gz"
    }

    exec { "tomcat_untar":
        command     => "tar xfz /tmp/apache-tomcat-${version}.tar.gz; $moveAfterExtractCommand",
        user        => "${userName}",
        cwd         => "/home/${userName}",
        creates     => "${tomcatInstallationDirectory}",
        path        => ["/bin"],
        require     => Exec["gettomcattarfile"],
        provider    => "shell",
    }

    file { "/etc/init.d/tomcat" :
        ensure      => present,
        content     => template("tomcat/tomcat.initd"),
        mode        => 777,
        group       => "root",
        owner       => "root",
        require     => Exec["tomcat_untar"],
    }

    file { "${tomcatInstallationDirectory}/conf/server.xml" :
        ensure      => present,
        content     => template("tomcat/server.xml.erb"),
        group       => "${userName}",
        owner       => "${userName}",
        replace     => true,
        require     => File["/etc/init.d/tomcat"],
    }

    file { "${tomcatInstallationDirectory}/conf/tomcat-users.xml" :
        ensure      => present,
        content     => template("tomcat/tomcat-users.xml.erb"),
        group       => "${userName}",
        owner       => "${userName}",
        require     => File["/etc/init.d/tomcat"],
    }

    exec { "installtomcatservice" :
        provider    => "shell",
        user        => "root",
        command     => "/sbin/chkconfig --add tomcat",
        require     => File["/etc/init.d/tomcat"],
        onlyif      => "chkconfig --list tomcat; [ $? -eq 1 ]"
    }

    service { "tomcat" :
        ensure      => running,
        enable      => true,
        hasstatus   => false,
        require     => Exec["installtomcatservice"],
    }
}
