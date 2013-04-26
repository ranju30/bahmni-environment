class {tomcat : require => Class["users"], version => "${tomcatVersion}", userName => "${jssUser}", tomcatManagerUserName => "${tomcatManagerUserName}",tomcatManagerPassword => "${tomcatManagerPassword}", tomcatHttpPort => "${tomcatHttpPort}", tomcatRedirectPort => "${tomcatRedirectPort}",tomcatShutdownPort => "${tomcatShutdownPort}", tomcatAjpPort => "${tomcatAjpPort}", tomcatInstallationDirectory => "${tomcatInstallationDirectory}"}
class {openmrs : require => Class["tomcat"], tomcatInstallationDirectory => "${tomcatInstallationDirectory}"}
include mysql
include mysqlserver