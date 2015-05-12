# Configuration of underlying software stack which are applicable at runtime

# Default values for expected FACTER variables
$bahmni_user = $bahmni_user_name ? {
  undef     => "bahmni",
  default       => $bahmni_user_name
}

$is_passive_setup = $deploy_passive ? {
  undef     => "false",
  default       => $deploy_passive
}

$bahmni_openerp_required = $deploy_bahmni_openerp ? {
  undef     => "true",
  default       => $deploy_bahmni_openerp
}

$bahmni_openelis_required = $deploy_bahmni_openelis ? {
  undef     => "true",
  default       => $deploy_bahmni_openelis
}

$support_email = $bahmni_support_email ? {
  undef     => "bahmni-jss-support@googlegroups.com",
  default       => $bahmni_support_email
}

import "runtime/app-server-configuration"
import "runtime/db-server-configuration"
import "runtime/nagios-remote-host-config"
import "runtime/nagios-server-configuration"
import "runtime/reports-configuration"

# Should be included after runtime variables
import "constants"