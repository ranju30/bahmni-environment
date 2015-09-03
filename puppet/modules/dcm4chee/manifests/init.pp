class dcm4chee{
  $bahmni_location = "/var/lib/bahmni"
  $dcm4chee_zip_filename = "dcm4chee-2.18.1-psql"
  $dcm4chee_location =  "${bahmni_location}/${dcm4chee_zip_filename}"
  $dcm4chee_server_default_location = "${dcm4chee_location}/server/default"
  $dcm4chee_server_xml_location = "${dcm4chee_server_default_location}/deploy/jboss-web.deployer"
  $dcm4chee_conf_location = "${dcm4chee_server_default_location}/conf"
  $dcm4chee_archive_directory = "${dcm4chee_server_default_location}/archive"

  $share_location = "/usr/share"
  $jboss_filename = "jboss-4.2.3.GA"
  $jboss_location = "${share_location}/${jboss_filename}"
  $jboss_zip_filename = "${jboss_filename}-jdk6"

  $oviyam2_war_filename = "oviyam2"
  $oviyam2_bin_foldername = "Oviyam-2.1-bin"

  if ($bahmni_pacs_required == "true") {
    file { "copy_install_script" :
      path      => "${temp_dir}/install_dcm4chee.sh",
      ensure    => present,
      content   => template ("dcm4chee/install_dcm4chee.sh"),
      owner     => "root",
      mode      => 664,
    }

    exec { "install_dcm4chee" :
      command     => "sh ${temp_dir}/install_dcm4chee.sh ${deployment_log_expression}",
      provider    => shell,
      path        => "${os_path}",
      user        => "root",
      require     => File["copy_install_script"],
    }

    file { "copy_server_xml" :
      path      => "${dcm4chee_server_xml_location}/server.xml",
      ensure    => present,
      content   => template ("dcm4chee/server.xml"),
      owner     => "root",
      mode      => 664,
      require   => Exec["install_dcm4chee"],
    }

    file { "copy_service_xml" :
      path      => "${dcm4chee_conf_location}/jboss-service.xml",
      ensure    => present,
      content   => template ("dcm4chee/jboss-service.xml"),
      owner     => "root",
      mode      => 664,
      require   => Exec["install_dcm4chee"],
    }

    file { "copy_oviyam2" :
      path    => "${temp_dir}/oviyam2.sh",
      ensure  => present,
      content => template ("dcm4chee/oviyam2.sh"),
      owner   => "root",
      mode    => 664,
    }

    exec { "exec_oviyam2" :
      command   => "sh ${temp_dir}/oviyam2.sh ${deployment_log_expression}",
      provider  => shell,
      path      => "${os_path}",
      require   => [File["copy_oviyam2"],Exec["install_dcm4chee"]],
      user      => "root",
    }

    file { "/etc/init.d/dcm4chee" :
      ensure      => present,
      content     => template("dcm4chee/dcm4chee.initd.erb"),
      mode        => 777,
      group       => "root",
      owner       => "root",
      require     => [File["copy_server_xml"], File["copy_service_xml"]],
    }

    file { "copy_start_script" :
      path      => "${temp_dir}/start_dcm4chee.sh",
      ensure    => present,
      content   => template ("dcm4chee/start_dcm4chee.sh"),
      owner     => "root",
      mode      => 664,
    }

    if $is_passive_setup == "false" {
      cron { "sync_dcm4chee_image_cron" :
        command => "rsync -rh --progress -i --itemize-changes --update --chmod=Du=r,Dg=rwx,Do=rwx,Fu=rwx,Fg=rwx,Fo=rwx -p ${dcm4chee_archive_directory}/ -e root@${passive_machine_ip}:${dcm4chee_archive_directory}",
        user    => "root",
        minute  => "*/1"
      }

      exec { "start_dcm4chee" :
        command     => "sh ${temp_dir}/start_dcm4chee.sh ${deployment_log_expression}",
        provider    => shell,
        path        => "${os_path}",
        user        => "root",
        require     => File["copy_start_script"],
      }

      file { [ "${dcm4chee_server_default_location}/work", "${dcm4chee_server_default_location}/work/jboss.web", "${dcm4chee_server_default_location}/work/jboss.web/localhost" ]:
        ensure => "directory",
        require   => Exec["start_dcm4chee"],
      }

      file { "copy_oviyam2_config_xml" :
        path      => "${dcm4chee_server_default_location}/work/jboss.web/localhost/oviyam2-1-config.xml",
        ensure    => present,
        content   => template ("dcm4chee/oviyam2-1-config.xml"),
        owner     => "root",
        mode      => 664,
        require   => Exec["start_dcm4chee"],
      }

    }
  }
}

class dcm4chee::database {
  $bahmni_location = "/var/lib/bahmni"
  $dcm4chee_zip_filename = "dcm4chee-2.18.1-psql"
  $dcm4chee_location =  "${bahmni_location}/${dcm4chee_zip_filename}"
  file { "init_DB" :
    path    => "${temp_dir}/initDB.sh",
    ensure  => present,
    content => template ("dcm4chee/initDB.sh"),
    owner   => "${bahmni_user}",
    mode    => 664,
  }

  file { "setup_DB" :
    path    => "${temp_dir}/setupDB.sql",
    ensure  => present,
    content => template ("dcm4chee/setupDB.sql"),
    owner   => "${bahmni_user}",
    mode    => 664,
  }

  exec { "${temp_dir}/initDB.sh" :
    command     => "sh ${temp_dir}/initDB.sh ${deployment_log_expression}",
    provider    => shell,
    path        => "${os_path}",
    user        => "${bahmni_user}",
    require     => [File["setup_DB"], File["init_DB"]],
  }
}
