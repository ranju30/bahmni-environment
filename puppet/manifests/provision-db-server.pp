import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"

node default {

    include mysql_server
    if ($bahmni_openerp_required == "true") or ($bahmni_openelis_required == "true") {
      include postgresql
    }

}