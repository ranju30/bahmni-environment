# Configuration of underlying software stack which are applicable at runtime

# user
# to generate password hash use 'echo "password" | openssl passwd -1 -stdin'
$bahmni_user = "jss"
$bahmni_user_password_hash = '$1$IW4OvlrH$Kui/55oif8W3VZIrnX6jL1' #p@ssw0rd
$ssh_port=22

# Machines
$primary_machine_ip = "192.168.0.152"
$secondary_machine_ip = "192.168.0.115"

# mysql
$mysqlRootPassword = "password"

## Postgres
$postgresMajorVersion ="9"
$postgresMinorVersion = "2"
$postgresUser="postgres"
$postgresMachine = "master" ## [master | slave]
$postgresMaster = $primary_machine_ip
$postgresSlave = $secondary_machine_ip

$postgresFirstTimeSetup=true # Use this for first time setup of master and slave
$postgresMasterDbFileBackup="/tmp/pg_master_db_file_backup.tar" # The path of master db backup tar file on slave

#Postgres calculated variables
$postgresServiceName = "postgresql-${postgresMajorVersion}.${postgresMinorVersion}"
$postgresDataFolder = "/var/lib/pgsql/${postgresMajorVersion}.${postgresMinorVersion}/data"

#Go Server for Downloading Builds
$build_source_dir = "http://172.18.2.11:8153"
#$build_source_dir = "https://ci-bahmni.thoughtworks.com"
$go_server_user = "guest"
$go_server_pwd = "p@ssw0rd"
$mrs_go_build_name = "Latest"
$erp_go_build_name = "Latest"
$elis_go_build_name = "Latest"
$reference_data_go_build_name = "Latest"
$source_code_branch = "master"

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
$httpd_deploy_dir="/var/www"

$bahmniAppsDirectory="${httpd_deploy_dir}/bahmniapps"
$bahmniConfigDirectory="${httpd_deploy_dir}/bahmni_config"

$uploadedFilesDirectory="${tomcatParentDirectory}/uploaded-files"

# Backup config
$backup_hour = 3 # 3 AM Every day  

# Bahmni core properties
$imagesDirectory="/home/${bahmni_user}/patient_images"
$imagesUrl="/patient_images"
$documentBaseDirectory="/home/${bahmni_user}/document_images"


######################## HTTPD CONFIG START#############################################
import "httpd-default-configuration"

## The following redirects can contain either a string or an array;
## If it is a string, the same is used for both ProxyPass and ProxyPassReverse rules;
## In case of array, 1st element of the array specifies ProxyPass rule and 2nd element specifies ProxyPassReverse rule.
$httpRedirects = [{path => "/jasperserver", redirectPath => "http://localhost:8080/jasperserver"}]
$httpsRedirects = [{path => "/openmrs", redirectPath => "http://localhost:8080/openmrs"},
                   {path => "/openelis", redirectPath => "http://localhost:8080/openelis"},
                   {path => "/reference-data", redirectPath => "http://localhost:8080/reference-data"}]
#Static webapps
$httpsStaticWebapps = [
					   {path => "/home", directory => "${bahmniAppsDirectory}/home"},
					   {path => "/adt", directory => "${bahmniAppsDirectory}/adt"},
					   {path => "/clinical", directory => "${bahmniAppsDirectory}/clinical"},
					   {path => "/registration", directory => "${bahmniAppsDirectory}/registration"},
					   {path => "/common", directory => "${bahmniAppsDirectory}/common"},
					   {path => "/components", directory => "${bahmniAppsDirectory}/components"},
					   {path => "/document-upload", directory => "${bahmniAppsDirectory}/document-upload"},
					   {path => "/images", directory => "${bahmniAppsDirectory}/images"},
					   {path => "/styles", directory => "${bahmniAppsDirectory}/styles"},
					   {path => "/lib", directory => "${bahmniAppsDirectory}/lib"},
					   {path => "/orders", directory => "${bahmniAppsDirectory}/orders"},
					   {path => "/trends", directory => "${bahmniAppsDirectory}/trends"},
					   {path => "${imagesUrl}", directory => "${imagesDirectory}"},
					   {path => "/document_images", directory => "${documentBaseDirectory}"},
                       {path => "/bahmni_config", directory => "${bahmniConfigDirectory}"}]
$httpsCachedDirectories = []                    
$httpsAggressiveCacheDisabledDirectories = []
$httpsSubdomains = [{subdomain => "openerp", url => "http://localhost:8069"}]

$httpdCacheDirectory = "/var/cache/mod_proxy"
$httpsCacheUrls = [{path => "/openmrs/ws/rest/v1/concept", expireTime => "20 minutes"}]
######################## HTTPD CONFIG END################################################

# Nagios
$nagios_server_ip = $secondary_machine_ip
$nagios_user = "nagios"
$nagios_machine_type = "server" # server | client
$support_email="bahmni-jss-support@googlegroups.com" # configured to allow devs to test using their own email id
$nagios_openmrs_user=admin
$nagios_openmrs_user_password=test

$smtp_host="gmail-smtp-in.l.google.com"
$from_email = "jss.bahmni@gmail.com"

$openelis_username="admin"
$openelis_password="adminADMIN!"

# OpenMRS
$openmrs_database_user = "openmrs-user"
$openmrs_database_password = "password"
$openmrs_password = "test"

# OpenERP properties used by OpenMRS
$openERPPort=8069
$openERPHost=localhost
$openERPDatabase=openerp
$openERPUser=admin
$openERPPassword=password

$openerpShellUser = "openerp"
$openerpGroup = "openerp"

$openERPConnectTimeout=10000
$openERPReadTimeout=20000

######################## JASPER CONFIG START##############################################
$jasperTomcatHome = $tomcatInstallationDirectory
$jasperHome = "/usr/local/jasperreports-server-cp-5.0.0-bin"
$jasperDbType = "mysql"
$jasperDbHost = "localhost"
$jasperDbUsername = "root"
$jasperDbPassword = "password"
$jasperDbName = "jasperserver"
######################## JASPER CONFIG END##############################################

##########################################################################
$ant_version="1.9.1"
$ant_home="/home/${bahmni_user}/apache-ant-${ant_version}"
