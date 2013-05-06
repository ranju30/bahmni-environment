class yum-repo {
	file { "local_repo" :
		path 			=> "/etc/yum.repos.d/local.repo",
    ensure    => present,
    content   => template("yum-repo/local.repo.erb"),
    mode      => 644
  }
}