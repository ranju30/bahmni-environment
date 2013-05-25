import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/stack-replication-slave-configuration"
import "configurations/deployment-configuration"

node default {
    include yum-repo
    include host
    include tools
    include java
    include mysql
    include mysqlserver
    include mysqlreplication
    class {users : userName => "${bahmni_user}", password_hash => "${bahmni_user_password_hash}"}
    include tomcat
    include httpd
    include jasperserver
    include python
    include postgresql
    include openerp
}