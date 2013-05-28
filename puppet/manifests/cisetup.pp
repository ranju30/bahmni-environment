import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"
import "configurations/cisetup-configuration"

node default {

	stage { "first" : before => Stage['main']}

	class { "bootstrap": stage => 'first'; }
  class { "yum-repo":  stage => 'first'; }
  class { "host":      stage => 'first'; }
  class { "users":
       stage         => "first",    
       userName      => "${bahmni_user}", 
       password_hash => "${bahmni_user_password_hash}"
  }

  include tools
  include java    
  include mysql
  include mysqlserver
  include tomcat
  include httpd
  include jasperserver
  include python
  include postgresql
  include openerp

  include maven
  include go-setup
}