class bootstrap {

  package {['createrepo', 'git']:
    ensure => present;
  }

  file {'/etc/yum.conf':
    source => "puppet:///modules/bootstrap/yum.conf"
  }

#  file {'/etc/yum.repos.d/local.repo':
#    source => "puppet:///modules/bootstrap/local.repo"
#  }

###  file {["/etc/yum.repos.d/CentOS-Base.repo", "/etc/yum.repos.d/epel.repo", "/etc/yum.repos.d/puppetlabs.repo", "/etc/yum.repos.d/pgdg-92-centos.repo"]:
  file {["/etc/yum.repos.d/epel.repo", "/etc/yum.repos.d/puppetlabs.repo", "/etc/yum.repos.d/pgdg-92-centos.repo"]:
     ensure => absent;
  }

#  exec { "createrepo --update /packages/localrepo":
##    path => ["/usr/bin", "/usr/local/bin", "/bin"],
#    require   => Package["createrepo", "git"],
#    logoutput => true;
#  }

}