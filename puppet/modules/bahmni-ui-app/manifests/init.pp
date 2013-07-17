class bahmni-ui-app($appName) {
  $appZipFile = "${build_output_dir}/${appName}.zip"
  $appDirectory = "${httpd_deploy_dir}/${appName}"

  file { "${appDirectory}" :
    ensure    => absent,
    recurse   => true,
    force     => true,
    purge     => true
  }

  exec { "deploy_bahmni-apps" :
    command   => "unzip -q -o $appZipFile -d ${appDirectory} ${deployment_log_expression}",
    provider  => shell,
    path      => "${os_path}",
    require   => File["${appDirectory}"]
  }
}