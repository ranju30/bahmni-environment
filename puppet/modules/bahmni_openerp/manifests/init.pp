class bahmni_openerp inherits bahmni_openerp::config {

  $bahmni_openerp_temp_dir = "${config::temp_dir}/bahmni-openerp"
  $add_email_appender = "${config::add_email_appender}"

  if (${ ::config::bahmni_openerp_required } == "true") {
    include bahmni_openerp_internal
  } else {
    notice ("Not installing OpenERP. ")
  }
}

class bahmni_openerp_internal {
  include bahmni_revisions
  $log4j_xml_file = "${::config::tomcatInstallationDirectory}/webapps/${openerp_atomfeed_war_file_name}/WEB-INF/classes/log4j.xml"
  $openerp_modules_zip_filename = "openerp-modules"


  file { "${bahmni_openerp_temp_dir}" :
    ensure    => absent,
    force     => true
  }

  exec { "bahmni_openerp_codebase" :
    provider => "shell",
    command  => "unzip -o -q ${::config::build_output_dir}/${openerp_modules_zip_filename}.zip -d ${bahmni_openerp_temp_dir}   ${::config::deployment_log_expression}",
    path     => "${config::os_path}",
    require  => File["${bahmni_openerp_temp_dir}"]
  }

## Mujir/Sush - Using puppet's {recurse => true} takes > 13 hours to complete!!!!!!
  exec { "change_group_rights_for_openerp_temp_folders_current_content" :
    provider => "shell",
    command  => "chown -R openerp:openerp $bahmni_openerp_temp_dir; chmod -R 775 $bahmni_openerp_temp_dir; ",
    path     => "${config::os_path}",
    require  => Exec["bahmni_openerp_codebase"],
  }

  exec { "change_group_rights_for_openerp_folders_current_content" :
    provider => "shell",
    command  => "chown -R openerp:openerp $openerp_install_location; chmod -R 775 $openerp_install_location; ",
    path     => "${config::os_path}",
    require  => Exec["change_group_rights_for_openerp_temp_folders_current_content"],
  }

  exec { "bahmni_openerp" :
    provider => "shell",
    command  => "cp -r ${bahmni_openerp_temp_dir}/${openerp_modules_zip_filename}/* ${openerp_install_location}/openerp/addons   ${::config::deployment_log_expression}",
    path     => "${config::os_path}",
    user     => "${openerpShellUser}",
    group    => "${openerpGroup}",
    require  => Exec["change_group_rights_for_openerp_folders_current_content"],
  }

  exec { "clear_openerp_atomfeed_webapp" :
    command   => "rm -rf ${::config::tomcatInstallationDirectory}/webapps/openerp-atomfeed-service",
    provider  => shell,
    path      => "${config::os_path}",
    require   => [Exec["bahmni_openerp"]],
    user      => "${::config::bahmni_user}"
  }

  exec { "latest_openerp_atomfeed_webapp" :
    command   => "unzip -o -q ${::config::build_output_dir}/${openerp_atomfeed_war_file_name}.war -d ${::config::tomcatInstallationDirectory}/webapps/openerp-atomfeed-service   ${::config::deployment_log_expression}",
    provider  => shell,
    path      => "${config::os_path}",
    require   => [Exec["clear_openerp_atomfeed_webapp"]],
    user      => "${::config::bahmni_user}"
  }

  file { "${config::temp_dir}/bahmni-openerp/run-liquibase.sh" :
    ensure      => present,
    content     => template("bahmni_openerp/run-liquibase.sh"),
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
    require     => [Exec["latest_openerp_atomfeed_webapp"]],
    mode        => 554
  }

  exec { "bahmni_openerp_data" :
    command     => "${config::temp_dir}/bahmni-openerp/run-liquibase.sh   ${::config::deployment_log_expression}",
    path        => "${config::os_path}",
    provider    => shell,
    cwd         => "${::config::tomcatInstallationDirectory}/webapps",
    require     => [File["${config::temp_dir}/bahmni-openerp/run-liquibase.sh"]]
  }

  file { "${log4j_xml_file}" :
    ensure      => present,
    content     => template("bahmni_openerp/log4j.xml.erb"),
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
    require     => Exec["latest_openerp_atomfeed_webapp"],
    mode        => 664,
  }

  if ("${::config::is_passive_setup}" == "false") {
    exec { "restart_openerp" :
      command   => "service openerp restart",
      provider  => shell,
      path      => "${config::os_path}",
      require   => [File["${log4j_xml_file}"]]
    }
  } else {
    notice ("Not starting OpenERP. ")
  }
}