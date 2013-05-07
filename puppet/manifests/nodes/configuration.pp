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
 $tomcatSessionTimeoutInMinutes = 120
 $tomcatManagerUserName = "tomcat"
 $tomcatHttpPort="8080"
 $tomcatRedirectPort="8443"
 $tomcatShutdownPort="8005"
 $tomcatAjpPort="8009"
 $tomcatParentDirectory="/home/${jssUser}"
 $tomcatInstallationDirectory = "${tomcatParentDirectory}/apache-tomcat-${tomcatVersion}"
 
 ######################## HTTPD CONFIG START#############################################
 ## HTTPD
 $sslEnabled = true
 $sslExcludeList = ["10.155.8.115","127.0.0.1","192.168.42.45"]
 $dropPacketsIfIPNotInSslExcludeList = false # true if the packets have to dropped when accessed over http

 ## The following redirects can contain either a string or an array;
 ## If it is a string, the same is used for both ProxyPass and ProxyPassReverse rules;
 ## In case of array, 1st element of the array specifies ProxyPass rule and 2nd element specifies ProxyPassReverse rule.
 $httpRedirects = ["/jasperserver http://localhost:8080/jasperserver"]
 $httpsRedirects = ["/openmrs http://localhost:8080/openmrs",
                    "/registration http://localhost:8080/registration"] #TODO: Deploy registration to apache directly <Deepak>

 ## HTTPS
 $SSLCertificateFile = "/etc/pki/tls/certs/localhost.crt"
 $SSLCertificateKeyFile = "/etc/pki/tls/private/localhost.key"
 $sslCertificateChainFile = "" ## Leave blank if no chain certificate is required.
 $sslCACertificateFile = "" ## Leave blank if no CA certificate is required.
 $serverName = "" ##ServerName entry in httpd and ssl conf

 ## Authentication
 $authenticationRequired = false     ## Specify if authentication is necessary.
 $authenticationKey = "APIKey"             ## The key which is to be authenticated.
 $authenticationValues = ["1234","5678"]           ## The values which must be compared for authentication.
 ## Use property httpsRedirects to setup proxypass redirects
 $authenticationExcludeHosts = []
 $authenticationExcludeUrlPatterns = []

 ######################## HTTPD CONFIG END################################################
 

# OpenERP properties used by OpenMRS
$openERPPort=8069
$openERPHost=localhost
$openERPDatabase=openerp
$openERPUser=admin
$openERPPassword=password

$imagesDirectory="/home/${jssUser}/patient_images"


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
 # class { httpd : sslEnabled => $sslEnabled, sslCertificateFile => "${SSLCertificateFile}", sslCertificateKeyFile => "${SSLCertificateKeyFile}", sslCertificateChainFile => $sslCertificateChainFile, sslCACertificateFile => $sslCACertificateFile, serverName => $serverName}
 # class {tomcat : require => Class["users"], version => "${tomcatVersion}", userName => "${jssUser}", tomcatManagerUserName => "${tomcatManagerUserName}",tomcatManagerPassword => "${tomcatManagerPassword}", tomcatHttpPort => "${tomcatHttpPort}", tomcatRedirectPort => "${tomcatRedirectPort}",tomcatShutdownPort => "${tomcatShutdownPort}", tomcatAjpPort => "${tomcatAjpPort}", tomcatInstallationDirectory => "${tomcatInstallationDirectory}"}
 # class {openmrs : require => Class["tomcat"], tomcatInstallationDirectory => "${tomcatInstallationDirectory}"}
 # class { ant: require => Class["users"]}
 # class { jasperserver : require => Class["tomcat"], userName => "${jssUser}"}
 # include mysql
 # include mysqlserver
 # include phantom-jasmine
 # include openerp
 # class {openmrs-demo-data : tomcatInstallationDirectory => "${tomcatInstallationDirectory}"}

