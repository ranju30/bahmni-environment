# Configuration of underlying software stack which are applicable at runtime

# Default values for expected FACTER variables
$bahmni_user = $bahmni_user_name ? {
  undef     => "bahmni",
  default       => $bahmni_user_name
}

$bahmni_openerp_required = $deploy_bahmni_openerp ? {
  undef     => "true",
  default       => $deploy_bahmni_openerp
}

$bahmni_openelis_required = $deploy_bahmni_openelis ? {
  undef     => "true",
  default       => $deploy_bahmni_openelis
}

$is_passive_setup = $deploy_passive ? {
  undef     => "false",
  default       => $deploy_passive
}

$reports_environment = $bahmni_reports_environment ? {
  undef     => "default",
  default       => $bahmni_reports_environment
}

# Machines
$active_machine_ip = $bahmni_active_machine_ip ? {
  undef     => "127.0.0.1",
  default       => $bahmni_active_machine_ip
}
$active_machine_host_name = $bahmni_active_machine_host_name ? {
  undef     => "emr01",
  default       => $bahmni_active_machine_host_name
}
$active_machine_alias = $bahmni_active_machine_alias ? {
  undef     => "emr01alias",
  default       => $bahmni_active_machine_alias
}
$passive_machine_ip = $bahmni_passive_machine_ip ? {
  undef     => "127.0.0.1",
  default       => $bahmni_passive_machine_host_name
}
$passive_machine_host_name = $bahmni_passive_machine_host_name ? {
  undef     => "passivehost",
  default       => $bahmni_passive_machine_host_name
}
$passive_machine_alias = $bahmni_passive_machine_alias ? {
  undef     => "passivealias",
  default       => $bahmni_passive_machine_alias
}

$db_server = $db_server_ip ? {
  undef     => "localhost",
  default       => $db_server_ip
}

$app_server = $app_server_ip ? {
  undef     => "localhost",
  default       => $app_server_ip
}

$passive_app_server = $passive_app_server_ip ? {
  undef     => "localhost",
  default       => $passive_app_server_ip
}

$postgresMachine = $is_passive_setup ? {
  "false"  => "master",
  undef     => "master",
  "true" => "slave"
}


$postgresMaster = $active_machine_ip
$postgresSlave = $passive_machine_ip

# Nagios
$nagios_server_ip = $bahmni_nagios_server_ip ? {
  undef     => "localhost",
  default       => $bahmni_nagios_server_ip
}

$support_email = $bahmni_support_email ? {
  undef     => "bahmni-jss-support@googlegroups.com",
  default       => $bahmni_support_email
}

import "constants"