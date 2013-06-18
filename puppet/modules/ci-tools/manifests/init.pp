class ci-tools {

  package { "git" :
    ensure => present,
  }

  package { "ruby" :
    ensure => present,
  }

  package { "rubygems" :
    ensure => present,
    require => Package["ruby"]            
  }

  package { "nodejs" :
            ensure => present;
  }

  package { "npm" :
            ensure  => present,
            require => Package["nodejs"],
  }

  exec { "karma":
            command     => "npm install -g karma",
            provider    => "shell",
            require     => Package["npm"],
  }

  exec { "phantomjs":
            command     => "npm install -g phantomjs",
            provider    => "shell",
            require     => Package["npm"],
  } 

  exec { "phantom-jasmine":
            command     => "npm install -g phantom-jasmine",
            provider    => "shell",
            require     => Package["npm"],
  }

  exec { "bower":
            command   => "npm install -g bower",
            provider  => "shell",
            require   => Package["npm"],
  }

  exec { "grunt-cli":
            command   => "npm install -g grunt-cli",
            provider  => "shell",
            require   => Package["npm"],
  }

  exec { "compass":
            command   => "gem install compass",
            provider  => "shell",
            require   => Package["rubygems"]
  }

}