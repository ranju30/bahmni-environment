class bahmni_jasperreports inherits bahmni_jasperreports::config {

  $properties_file = "reports_${reports_environment}.properties"

  exec { "delete_reports_dir" :
    command => "rm -rf ${::config::build_output_dir}/${implementation_name}-reports",
    path    => "${config::os_path}"
  }

  file { "delete_reports_zip" :
    path      => "${::config::build_output_dir}/${implementation_name}-reports.zip",
    ensure    => absent,
    force     => true,
  }

  exec { "download_reports_zip":
    command => "/usr/bin/wget --no-check-certificate ${config::report_zip_source_url} -O ${implementation_name}-reports.zip",
    cwd     => "${::config::build_output_dir}",
    require => [Exec["delete_reports_dir"], File["delete_reports_zip"]],
    timeout => 0
  }

  exec { "unzip_report" :
    command   => "unzip -q -o ${implementation_name}-reports.zip -d ${::config::build_output_dir}/${implementation_name}-reports   ${::config::deployment_log_expression}",
    provider  => shell,
    path      => "${config::os_path}",
    cwd       => "${::config::build_output_dir}",
    require   => Exec["download_reports_zip"]
  }

  exec { "change-reports-name":
    command   => "mv *-master ${implementation_name}-reports-master",
    path      => "${config::os_path}",
    provider  => shell,
    cwd       => "${::config::build_output_dir}/${implementation_name}-reports",
    require   => Exec["unzip_report"]
  }

  exec { "bahmni-jasperserver-deploy-reports" :
    provider => "shell",
    command  => "scripts/deploy.sh -j ${config::jasperHome} -p conf/${properties_file}   ${::config::deployment_log_expression}",
    path     => "${config::os_path}",
    cwd      => "${::config::build_output_dir}/${implementation_name}-reports/${implementation_name}-reports-master",
    require  => Exec["change-reports-name"]
  }

  exec { "bahmni-jasperserver-deploy-customserver" :
    provider => "shell",
    command  => "scripts/deployCustomJasperServer.sh ${config::jasperHome}   ${::config::deployment_log_expression}",
    path     => "${config::os_path}",
    cwd      => "${::config::build_output_dir}/${implementation_name}-reports/${implementation_name}-reports-master",
    onlyif   => "test -f scripts/deployCustomJasperServer.sh",
    require  => Exec["bahmni-jasperserver-deploy-reports"]
  }
}