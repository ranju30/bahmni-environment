class global::runtime {
  
  $bahmni_user = $bahmni_user_name ? { undef => "bahmni", default => $bahmni_user_name }
  $bahmni_openerp_required = $deploy_bahmni_openerp ? { undef => "true", default => $deploy_bahmni_openerp }
  $bahmni_openelis_required = $deploy_bahmni_openelis ? { undef => "true", default => $deploy_bahmni_openelis }

  $implementation_name = $implementation_name ? { undef => "default", default => $implementation_name }
  $is_passive_setup = $deploy_passive ? { undef => "false", default => $deploy_passive }
  $support_email = $bahmni_support_email ? { undef => "bahmni-jss-support@googlegroups.com", default => $bahmni_support_email }

  $add_email_appender = $bahmni_add_email_appender ? { undef => "false", default => $bahmni_add_email_appender }

  $db_server = $db_server_ip ? { undef => "127.0.0.1", default => $db_server_ip }
  $passive_db_server = $passive_db_server_ip ? { undef => "127.0.0.1", default => $passive_db_server_ip }
  $app_server = $app_server_ip ? { undef => "127.0.0.1", default => $app_server_ip }
  $passive_app_server = $passive_app_server_ip ? { undef => "127.0.0.1", default => $passive_app_server_ip }

  $reports_environment = $bahmni_reports_environment ? { undef => "default", default => $bahmni_reports_environment }

  $nagios_server_ip = $bahmni_nagios_server_ip ? { undef => "localhost", default => $bahmni_nagios_server_ip }
  
}