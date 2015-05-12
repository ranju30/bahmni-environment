$db_server = $db_server_ip ? {
  undef     => "localhost",
  default       => $db_server_ip
}

$passive_db_server = $passive_db_server_ip ? {
  undef     => "localhost",
  default       => $passive_db_server_ip
}

$app_server = $app_server_ip ? {
  undef     => "localhost",
  default       => $app_server_ip
}

$passive_app_server = $passive_app_server_ip ? {
  undef     => "localhost",
  default       => $passive_app_server_ip
}
