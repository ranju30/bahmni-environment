include mysql
include mysqlserver

# class {users : userName => "${bahmni_user}", password_hash => "${bahmni_user_password_hash"}
# class {tomcat : version => "${tomcatVersion}", userName => "${bahmni_user}", tomcatManagerUserName => "${tomcatManagerUserName}",tomcatManagerPassword => "${tomcatManagerPassword}", tomcatHttpPort => "${tomcatHttpPort}", tomcatRedirectPort => "${tomcatRedirectPort}",tomcatShutdownPort => "${tomcatShutdownPort}", tomcatAjpPort => "${tomcatAjpPort}", tomcatInstallationDirectory => "${tomcatInstallationDirectory}"}
# class {openmrs : tomcatInstallationDirectory => "${tomcatInstallationDirectory}"}