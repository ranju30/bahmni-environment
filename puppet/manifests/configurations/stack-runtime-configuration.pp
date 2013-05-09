# Configuration of underlying software stack which are applicable at runtime

# user
# to generate password hash use 'echo "password" | openssl passwd -1 -stdin'
$bahmni_user = "jss"
$bahmni_user_password_hash = '$1$IW4OvlrH$Kui/55oif8W3VZIrnX6jL1' #p@ssw0rd

# mysql
$mysqlRootPassword = "password"

#Tomcat 7
$tomcatManagerUserName = "tomcat"
$tomcatManagerPassword = "p@ssw0rd"
$tomcatHttpPort="8080"
$tomcatRedirectPort="8443"
$tomcatShutdownPort="8005"
$tomcatAjpPort="8009"
$tomcatParentDirectory="/home/${bahmni_user}"
$tomcatInstallationDirectory = "${tomcatParentDirectory}/apache-tomcat-${tomcat_version}"
$tomcatSessionTimeoutInMinutes = 120

$deployablesDirectory="/home/${bahmni_user}/deployables"

# Set host name or ip address
$deployHost="localhost"
$deployDirectory="/var/www"

$registrationAppDirectory="${deployablesDirectory}/registration"

######################## HTTPD CONFIG START#############################################
## HTTPD
$sslEnabled = true
$sslExcludeList = ["127.0.0.1"]
$dropPacketsIfIPNotInSslExcludeList = false # true if the packets have to dropped when accessed over http


## The following redirects can contain either a string or an array;
## If it is a string, the same is used for both ProxyPass and ProxyPassReverse rules;
## In case of array, 1st element of the array specifies ProxyPass rule and 2nd element specifies ProxyPassReverse rule.
$httpRedirects = ["/jasperserver http://${deployHost}:8080/jasperserver"]
$httpsRedirects = ["/openmrs http://${deployHost}:8080/openmrs"]
$httpsStaticWebapps = ["/registration ${registrationAppDirectory}", "/patient_images ${deployDirectory}/patient_images"]
$httpsCachedDirectories = ["${registrationAppDirectory}/lib", "${registrationAppDirectory}/css/lib"]                    
$httpsAggressiveCacheDisabledDirectories = ["${registrationAppDirectory}/modules"]

## HTTPS
$sslCertificateFile = "/etc/pki/tls/certs/localhost.crt"
$sslCertificateKeyFile = "/etc/pki/tls/private/localhost.key"
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

#OpenMRS
$openmrs_password = "Admin123"

# OpenERP properties used by OpenMRS
$openERPPort=8069
$openERPHost=localhost
$openERPDatabase=openerp
$openERPUser=admin
$openERPPassword=password

######################## JASPER CONFIG START##############################################
$jasperTomcatHome = $tomcatInstallationDirectory
$jasperHome = "/usr/local/jasperreports-server-cp-5.0.0-bin"
$jasperDbType = "mysql"
$jasperDbHost = "localhost"
$jasperDbUsername = "root"
$jasperDbPassword = "password"
$jasperDbName = "jasperserver"
######################## JASPER CONFIG END##############################################

# Bahmni core properties
$imagesDirectory="/home/${bahmni_user}/patient_images"
$protocol = $sslEnabled ? { true => 'https', default =>  'http'}
$imagesUrl="${protocol}://${deployHost}/patient_images"