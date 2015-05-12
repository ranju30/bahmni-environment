$app_server = $app_server_ip ? {
  undef     => "localhost",
  default       => $app_server_ip
}

$passive_app_server = $passive_app_server_ip ? {
  undef     => "localhost",
  default       => $passive_app_server_ip
}

$active_machine_ip = $bahmni_active_machine_ip ? {
  undef     => "127.0.0.1",
  default       => $bahmni_active_machine_ip
}

$passive_machine_ip = $bahmni_passive_machine_ip ? {
  undef     => "127.0.0.1",
  default       => $bahmni_passive_machine_host_name
}

$postgresMaster = $active_machine_ip
$postgresSlave = $passive_machine_ip
