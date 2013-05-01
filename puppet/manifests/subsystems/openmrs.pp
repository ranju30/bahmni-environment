include mysql
include mysqlserver

class {users : userName => "${bahmni_user}", password_hash => "${bahmni_user_password_hash}"}
include tomcat
include openmrs