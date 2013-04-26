# Configuration of underlying software stack which are applicable at runtime

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