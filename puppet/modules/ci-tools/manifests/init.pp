class ci-tools {

  package { "git" :
            ensure => present,
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



}