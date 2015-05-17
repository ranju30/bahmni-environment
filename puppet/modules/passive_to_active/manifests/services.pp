class passive_to_active::services inherits passive_to_active::config {

  notice("starting applications...")

  notice("starting httpd...")
  service { "httpd":
    enable    => true,
    ensure    => running
  }

  notice("starting tomcat...")
  exec{ "start-tomcat":
    command  => "service tomcat start",
    user     => "root",
    path     => "${config::os_path}",
    provider => "shell"
  }

  if "${::config::bahmni_openerp_required}" == "true" {
    notice("starting openerp...")
    exec{ "start-openerp":
      command  => "service openerp start",
      user     => "root",
      path     => "${config::os_path}",
      provider => "shell"
    }
  }
}