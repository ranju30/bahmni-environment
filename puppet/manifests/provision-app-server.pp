import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"

stage { 'first_stage' : before => Stage['main'] }

node default {

    class { 'python_setuptools': stage => 'first_stage' }
    include tomcat
    include httpd 
    if $bahmni_openerp_required == "true" {
      include python
      class { 'openerp': require => Class["python"] }
    }
  
}