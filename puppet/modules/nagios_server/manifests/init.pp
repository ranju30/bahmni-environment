class nagios_server {
  
    require yum_repo
  
    package { "nagios" :
        ensure  =>  "present"
    }

    package { "nagios-plugins-nrpe" :
        ensure  => "present"
    }

    package { "mailx" :
        ensure  =>  "present"
    }
}