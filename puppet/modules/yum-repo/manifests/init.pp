class yum-repo {
  require bootstrap

  notice("yum-repo manifest being executed... ")

	file { "local_repo" :
		path 			=> "/etc/yum.repos.d/local.repo",
    ensure    => present,
    content   => template("yum-repo/local.repo.erb"),
    mode      => 664
  }

  exec { "update" :
  	command => "createrepo --update ${local_repo_path}",
  	path 		=> "${os_path}",
  	require => File["local_repo"]
  }

  exec { "touch" :
  	command => "touch /etc/yum.repos.d/${local_repo_name}.repo",
  	path 		=> "${os_path}",
  	require => Exec["update"]
  }

  if ($keep_linux_repos_enabled == "true") {

    notice("keep_linux_repos_enabled = true")

    file { "/etc/yum.repos.d/CentOS-Base.repo" :
      source => "puppet:///modules/yum-repo/CentOS-Base.repo",
      require => Exec["touch"]
    }

    file { "/etc/yum.repos.d/epel.repo" :
      source => "puppet:///modules/yum-repo/epel.repo",
      require => Exec["touch"]
    }

    file { "/etc/yum.repos.d/pgdg-92-centos.repo" :
      source => "puppet:///modules/yum-repo/pgdg-92-centos.repo",
      require => Exec["touch"]
    }

} else {

    notice("keep_linux_repos_enabled = false")

  #  file {'/etc/yum.repos.d/local.repo':
  #    source => "puppet:///modules/bootstrap/local.repo"
  #  }

    file {["/etc/yum.repos.d/epel.repo", "/etc/yum.repos.d/puppetlabs.repo", "/etc/yum.repos.d/pgdg-92-centos.repo"]:
      ensure => absent,
      require => Exec["touch"]
    }      
  }

}