class openerp () {

   exec {"get_openerpserver":
        command     => "/usr/bin/wget -O /tmp/openerp-7.0-latest.tar.gz http://nightly.openerp.com/7.0/nightly/src/openerp-7.0-latest.tar.gz                          ",
        timeout     => 0,
        provider    => "shell",
        user        => "${jssUser}",
        onlyif      => "test ! -f /tmp/openerp-7.0-latest.tar.gz"
    }

  file { "${openerpHome}":
            ensure      => "directory",
            purge       => true,
            owner       => "${jssUser}",
            group       => "${jssUser}"
    }

    exec { "unzip_openerpserver":
        command     => "unzip /tmp/openerp-7.0-latest.tar.gz && cp -r /user/local/openerp-7.0 ./ && rm -rf /tmp/openerp-7.0-20130122-001415",
        provider    => "shell",
        require     => [File["${openerpHome}"], Exec["get_openerpserver"]],
    }

 file { "${openerpHome}/install_dependancies.sh":
        content     => template("openerp/install_dependancies.sh"),
        owner       => "${jssUser}",
        group       => "${jssUser}"
    }
}
