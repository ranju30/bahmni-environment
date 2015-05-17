class bahmni_ui_apps inherits bahmni_ui_apps::config {
  
  $appName = "bahmniapps"
  $appZipFile = "${::config::build_output_dir}/${appName}.zip"
  $appDirectory = "${httpd_deploy_dir}/${appName}"
  
  file { "${httpd_deploy_dir}" :
    ensure      => directory,
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
    mode        => 775,
  }

  exec { "change_rights_for_httpd_deploy_dir" :
    provider => "shell",
    command => "chown -R ${::config::bahmni_user}:${::config::bahmni_user} ${httpd_deploy_dir}; chmod -R ug+w,a+r ${httpd_deploy_dir}",
    path => "${config::os_path}",
    require => File["${httpd_deploy_dir}"],
  }

  exec { "delete_${appDirectory}" :
    command => "rm -rf ${appDirectory}",
    path    => "${config::os_path}",
    require => Exec["change_rights_for_httpd_deploy_dir"]
  }

  exec { "deploy_bahmni_ui_app_${appName}" :
    command   => "unzip -q -o $appZipFile -d ${appDirectory}   ${::config::deployment_log_expression}",
    provider  => shell,
    path      => "${config::os_path}",
    require   => Exec["delete_${appDirectory}"]
  }

  exec { "change_rights_for_app_directory_${appDirectory}" :
    provider => "shell",
    command => "chown -R ${::config::bahmni_user}:${::config::bahmni_user} ${appDirectory}; chmod -R 775 ${appDirectory}",
    path => "${config::os_path}",
    require => Exec["deploy_bahmni_ui_app_${appName}"],
  }
}