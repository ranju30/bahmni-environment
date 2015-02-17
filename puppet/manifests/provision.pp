import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"

stage { 'all-repo-creation' : before => Stage['main'] }

node default {

	class { 'yum_repo': stage => 'all-repo-creation' }
	
	include host
	include tools
 	include java
	include mysql
	include mysqlserver
	include postgresql		
	class { 'users' : userName => "${bahmni_user}", password_hash => "${bahmni_user_password_hash}"}
	include tomcat
	class { 'tomcat_conf': require => Class["tomcat"] }
	include httpd
	class { 'jasperserver': require => Class["tomcat"] }
	if $bahmni_openerp_required == "true" {
	 	include python
		class { 'openerp': require => Class["python", "postgresql"] }
	}
#	include nagios
#	include bahmni_nagios
	include cron_tab
}