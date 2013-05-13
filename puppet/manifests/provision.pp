import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"

node default {
	include host
	include yum-repo
	include tools
 	include java
	include mysql
	include mysqlserver
	class {users : userName => "${bahmni_user}", password_hash => "${bahmni_user_password_hash}"}
	include tomcat
	include httpd 
  include jasperserver
 	include python
 	include postgresql
	include openerp
	include openmrs-setup
}