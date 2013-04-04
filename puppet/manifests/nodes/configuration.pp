 #-----------------------------MOTECH BOOTSTRAP---------------------------------------
 #  Save and exit to continue with setup.
 #------------------------------------------------------------------------------------

 #--------------------------------SETTINGS--------------------------------------------
 # operatingsystem
 $os = "centos5" #[centos5 | centos6]
 $word = "32b" #[32b,64b]
 $arch = "x64" # [x64|i586]

 # user
 # to generate password hash use 'echo "password" | openssl passwd -1 -stdin'
 $jssUser = "jss"
 $jssPassword = '$1$IW4OvlrH$Kui/55oif8W3VZIrnX6jL1'

 # mysql
 $mysqlRootPassword = "password"

 # Openmrs
 $openMRSVersion = "1.9.2"

 # Java
 $javaHome="/usr/lib/jvm/jre1.7.0"

 #Tomcat 7.0.22 configuration

 $tomcatManagerPassword = "p@ssw0rd"
 $tomcatVersion = "7.0.22"

 ## optional
 $tomcatManagerUserName = "tomcat"
 $tomcatHttpPort="8080"
 $tomcatRedirectPort="8443"
 $tomcatShutdownPort="8005"
 $tomcatAjpPort="8009"
 $tomcatParentDirectory="/home/${jssUser}"
 $tomcatInstallationDirectory = "${tomcatParentDirectory}/apache-tomcat-${tomcatVersion}"
 

 ######################## JASPER CONFIG START##############################################
 $jasperTomcatHome = $tomcatInstallationDirectory
 $jasperHome = "/usr/local/jasperreports-server-cp-5.0.0-bin"
 $jasperDbType = "mysql"
 $jasperDbHost = "localhost"
 $jasperDbUsername = "root"
 $jasperDbPassword = "password"
 $jasperDbName = "jasperserver"
 $jasperResetDb = "y" ## Provide "y" or "n"
 ######################## JASPER CONFIG END################################################


 #--------------------------------RESOURCES--------------------------------------------
 # comment out resources not required to be installed

 # class {users : userName => "${jssUser}", password => "${jssPassword}" }
 # class {tomcat : require => Class["users"], version => "${tomcatVersion}", userName => "${jssUser}", tomcatManagerUserName => "${tomcatManagerUserName}",tomcatManagerPassword => "${tomcatManagerPassword}", tomcatHttpPort => "${tomcatHttpPort}", tomcatRedirectPort => "${tomcatRedirectPort}",tomcatShutdownPort => "${tomcatShutdownPort}", tomcatAjpPort => "${tomcatAjpPort}", tomcatInstallationDirectory => "${tomcatInstallationDirectory}"}
 # class {openmrs : tomcatInstallationDirectory => "${tomcatInstallationDirectory}"}
 # class { ant: require => Class["users"]}
 # class { jasperserver : userName => "${jssUser}"}
 # include mysql
 # include mysqlserver
 # include phantom-jasmine
 # include openerp
 # class {openmrs-demo-data : tomcatInstallationDirectory => "${tomcatInstallationDirectory}"}


#------------------------------------ Registration ------------------------------------------
$registrationZipFilePath = "/deploy/registration.zip"
$tomcatWebappDir = "/usr/local/Cellar/tomcat/7.0.37/libexec/webapps"

# include registration:deploy

