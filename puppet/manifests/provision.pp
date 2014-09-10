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
	class { 'users' : userName => "${bahmni_user}", password_hash => "${bahmni_user_password_hash}"}
	include tomcat
	include httpd
	class { 'jasperserver': require => Class["tomcat"] }
	if $deploy_bahmni_openelis == "true" or $deploy_bahmni_openerp == "true" {
		include postgresql		
	}
	if $deploy_bahmni_openerp == "true" {
	 	include python
		class { 'openerp': require => Class["python", "postgresql"] }
	}
#	include nagios
#	include bahmni_nagios
	include cron_tab
}