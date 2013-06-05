class git-nodejs-karma {

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

}