class yum-repo {
	file { "local_repo" :
		path 			=> "/etc/yum.repos.d/local.repo",
    ensure    => present,
    content   => template("yum-repo/local.repo.erb"),
    mode      => 644
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
}