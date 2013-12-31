class bahmni-artifacts {
  $download_build_file = "${scripts_dir}/download-build.sh"

  file { "${scripts_dir}" :
    ensure => directory,
    owner   => "root",
  }

  file { "${download_build_file}" :
    ensure      => present,
    content     => template("bahmni-artifacts/download-build.sh.erb"),
    mode        => 664,
    require     => File["${scripts_dir}"]
  }

  exec { "download_build" :
    command   => "sh ${scripts_dir}/download-build.sh ${deployment_log_expression}",
    provider  => shell,
    user      => "root",
    require 	=> File["$download_build_file"],
    cwd       => "${build_dir}",
    timeout   => 0
  }
}