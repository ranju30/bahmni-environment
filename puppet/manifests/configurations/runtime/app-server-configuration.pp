$db_server = $db_server_ip ? {
  undef     => "localhost",
  default       => $db_server_ip
}