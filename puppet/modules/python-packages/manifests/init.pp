class python-packages {
  $download_python_packages_file = "${scripts_dir}/download_python_packages.sh"

  file { "${scripts_dir}" :
    ensure => directory,
    owner   => "root",
  }

  file { "${download_python_packages_file}" :
    ensure      => present,
    content     => template("python-packages/download_python_packages.sh.erb"),
    mode        => 664,
    require     => File["${scripts_dir}"]
  }

  exec { "download_build" :
    command     => "sh ${download_python_packages_file} ${deployment_log_expression}",
    provider  => shell,
    user      => "root",
    require     => File["$download_python_packages_file"],
    cwd       => "${python_package_dir}"
  }
}