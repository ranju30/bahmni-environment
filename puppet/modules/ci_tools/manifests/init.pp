class ci_tools {
  require node_requirements
  require nodejs


  # Mujir - added this dependency so we can start openerp service
  require bahmni_openerp_basedata

  package { "xorg-x11-server-Xvfb" :
    ensure  => present,
  }

  package { "firefox" :
    ensure  => present,
      require => Package["xorg-x11-server-Xvfb"],
  }

  exec {"dbus-uuidgen" : 
    command  => "dbus-uuidgen > /var/lib/dbus/machine-id;",
    provider => "shell",
    require  => Package["firefox"]
  }
  
  file { '/usr/bin/npm':
   ensure => 'link',
   target => '/usr/lib/node_modules/npm/bin/npm-cli.js',
  }

  exec { "phantomjs":
    command   => "npm install -g phantomjs",
    provider  => "shell",
    require   => File["/usr/bin/npm"],
    path      => "${os_path}"
  }
  
  exec { "bower":
    command   => "npm install -g bower",
    provider  => "shell", 
    require   => File["/usr/bin/npm"],
    path      => "${os_path}"
  }

  exec { "grunt-cli":
    command   => "npm install -g grunt-cli",
    provider  => "shell",
    require   => File["/usr/bin/npm"],
    path      => "${os_path}"
  }

# Mujir - needed by OPD build. Once we move OPD to grunt, remove this!!
 # exec { "karma":
 #   command     => "npm install -g karma",
 #   provider    => "shell",
 #   require     => Package["npm"],
 # }

}

class node_requirements{
  file{ "/usr/lib/node_modules": 
    ensure  => directory,
    mode    => 755,
    before  =>  Exec["Inflate"]
  }
}