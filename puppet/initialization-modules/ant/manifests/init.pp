class ant {
  exec {"getanttarfile" :
  	command => "/usr/bin/wget -O /tmp/ant.tar.gz http://apache.techartifact.com/mirror//ant/binaries/apache-ant-1.9.0-bin.tar.gz",
    timeout => 0,
    provider => "shell",
    onlyif  => "test ! -d /home/${jssUser}/apache-ant-1.9.0",
   }
	
  exec { "ant_untar" :
    command => "tar zxf /tmp/ant.tar.gz",
    user    => "${jssUser}",
    cwd     => "/home/${jssUser}",
    creates => "/home/${jssUser}/apache-ant-1.9.0",
    path    => ["/bin",],
    require => [Exec['getanttarfile']],
  }
}