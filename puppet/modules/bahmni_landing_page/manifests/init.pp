class bahmni_landing_page {

  file { "copy_bahmni_landing_page_to_temp" :
    path    => "${temp_dir}/index.html",
    ensure  => present,
    content => template ("bahmni_landing_page/index.html"),
    owner   => "${bahmni_user}",
    mode    => 664,
  }

  exec { "copy_bahmni_landing_page_to_temp" :
    command     => "cp ${temp_dir}/index.html ${$httpd_deploy_dir}/html",
    path        => "${os_path}",
  }
}
