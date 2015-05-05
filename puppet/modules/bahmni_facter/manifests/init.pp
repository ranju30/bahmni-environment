class bahmni_facter {

file { "${bahmni_config_dir}" :
  ensure    => directory,
  recurse   => true,
  force     => true,
  mode      => 777
}

file { ["/etc/facter/", "/etc/facter/facts.d" ]:
  ensure    => directory,
  recurse   => true,
  force     => true,
  mode      => 777
}

file { "/tmp/setEnv.sh" :
  ensure      => present,
  content     => template("bahmni_facter/setEnv.sh.erb"),
  require    => [File["${bahmni_config_dir}"],File["/etc/facter/facts.d"]]
}

exec {"set_env" :
  command        => "sudo sh /tmp/setEnv.sh",
  provider    => shell,
  user        => "root",
  require    => [File["/tmp/setEnv.sh"]]
}

}