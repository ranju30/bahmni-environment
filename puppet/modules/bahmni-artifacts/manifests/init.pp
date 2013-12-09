class bahmni-artifacts {
  $download-build-file = "${scripts_dir}/download-build.sh"

  file { "${scripts_dir}" :
    ensure => directory,
    owner   => "root",
  }

  file { "${download-build-file}" :
    ensure      => present,
    content     => template("bahmni-artifacts/download-build.sh.erb"),
    mode        => 664,
    require     => File["${scripts_dir}"]
  }

  exec { "download_build" :
    command   => "sh ${scripts_dir}/download-build.sh ${deployment_log_expression}",
    provider  => shell,
    user      => "root",
    require   => File["$download-build-file"],
    cwd       => "${build_dir}"
  }
}