class nagios_config inherits global {
  $active_machine_ip = $bahmni_active_machine_ip ? {
    undef     => "127.0.0.1",
    default       => $bahmni_active_machine_ip
  }

  $passive_machine_ip = $bahmni_passive_machine_ip ? {
    undef     => "127.0.0.1",
    default       => $bahmni_passive_machine_host_name
  }

  $active_machine_host_name = $bahmni_active_machine_host_name ? {
    undef     => "emr01",
    default       => $bahmni_active_machine_host_name
  }
  $active_machine_alias = $bahmni_active_machine_alias ? {
    undef     => "emr01alias",
    default       => $bahmni_active_machine_alias
  }
  $passive_machine_host_name = $bahmni_passive_machine_host_name ? {
    undef     => "passivehost",
    default       => $bahmni_passive_machine_host_name
  }
  $passive_machine_alias = $bahmni_passive_machine_alias ? {
    undef     => "passivealias",
    default       => $bahmni_passive_machine_alias
  }
}