class ci-tools {
  require node_requirements
  require nodejs

  # Mujir/Sush - This external puppet module installs git
  require rvm

  # Mujir - added this dependency so we can start openerp service
  require bahmni-openerp-basedata

  service { "openerp":
      enable => true,
      ensure => running
  }

  # Capybara needs ruby > 1.9.3
  rvm_system_ruby { '1.9.3':
    ensure => 'present',
    default_use => false;
  }

  # Go needs ruby 1.8
  rvm_system_ruby { '1.8':
    ensure => 'present',
    default_use => true;
  }

  rvm_gem { 'bundler':  
    name => 'bundler',
    ruby_version => '1.9.3',
    ensure => latest,
    require => Rvm_system_ruby['1.9.3'];
  }
  rvm_gem { 'i18n':
    name => 'i18n',
    ruby_version => '1.9.3',
    ensure => latest,
    require => Rvm_gem['bundler'];
  }
  rvm_gem { 'nokogiri':
    name => 'nokogiri',
    ruby_version => '1.9.3',
    ensure => latest,
    require => Rvm_gem['i18n'];
  }
  rvm_gem { 'capybara':
    name => 'capybara',
    ruby_version => '1.9.3',
    ensure => latest,
    require => Rvm_gem['nokogiri'];
  }
  rvm_gem { 'compass':
    name => 'compass',
    ruby_version => '1.9.3',
    ensure => latest,
    require => Rvm_gem['capybara'];
  }

  # Mujir - is there a clean way to do this.
  group { "rvm" :
    ensure  => "present",
    require => Rvm_system_ruby['1.9.3'],
  }
  # Mujir - is there a clean way to do this.
  exec { "make rvm group owner of rvm gems" :
    #command => "chgrp -R rvm `rvm gemdir 1.9.3`",
    command => "chgrp -R rvm /usr/local/rvm/gems/ruby-1.9.3-p429",
    path => "${os_path}",
    require => Group["rvm"],
  }

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
}

class node_requirements{
  file{ "/usr/lib/node_modules":
    ensure  => directory,
    mode    => 755,
    before  =>  Exec["Inflate"]
  }
}