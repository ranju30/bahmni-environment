class tomcat ( $version, $userName, $tomcatManagerUserName = "tomcat", $tomcatManagerPassword, $tomcatHttpPort = "8080", $tomcatRedirectPort = "8443", $tomcatShutdownPort = "8005", $tomcatAjpPort = "8009") {

    $tomcatInstallationDirectory = "/home/${userName}/apache-tomcat-${version}"

    exec { "install-tomcat" :
     command => "yum install tomcat --installroot ${tomcatInstallationDirectory}"
     }

    file { "/etc/init.d/tomcat" :
        ensure      => present,
        content     => template("tomcat/tomcat.initd"),
        mode        => 777,
        group       => "root",
        owner       => "root",
        require     => Exec["install-tomcat"],
    }

    file { "$tomcatInstallationDirectory/conf/server.xml" :
        ensure      => present,
        content     => template("tomcat/server.xml.erb"),
        group       => "${userName}",
        owner       => "${userName}",
        replace     => true,
        require     => File["/etc/init.d/tomcat"],
    }

    file { "$tomcatInstallationDirectory/conf/tomcat-users.xml" :
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

    service { "tomcat$" :
        ensure      => running,
        enable      => true,
        hasstatus   => false,
        require     => Exec["installtomcatservice"],
    }
}
