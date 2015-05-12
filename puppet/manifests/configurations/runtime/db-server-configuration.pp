$app_server = $app_server_ip ? {
  undef     => "localhost",
  default       => $app_server_ip
}

$postgresMachine = $is_passive_setup ? {
  "false"  => "master",
  undef     => "master",
  "true" => "slave"
}

$passive_app_server = $passive_app_server_ip ? {
  undef     => "localhost",
  default       => $passive_app_server_ip
}

$postgresMaster = $active_machine_ip
$postgresSlave = $passive_machine_ip
