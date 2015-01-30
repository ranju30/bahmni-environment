# Configuration of underlying software stack which are applicable at runtime

# user
# to generate password hash use 'echo "password" | openssl passwd -1 -stdin'

$bahmni_user_password_hash = '$1$IW4OvlrH$Kui/55oif8W3VZIrnX6jL1' #p@ssw0rd
$ssh_port=22

# Default values for expected FACTER variables
$bahmni_user = $bahmni_user_name ? {
      undef     => "bahmni",
      default       => $bahmni_user_name
}

$bahmni_openerp_required = $deploy_bahmni_openerp ? {
      undef     => "true",
      default       => $deploy_bahmni_openerp
}

$bahmni_openelis_required = $deploy_bahmni_openelis ? {
      undef     => "true",
      default       => $deploy_bahmni_openelis
}

$install_server_type = $bahmni_server_type ? {
      undef     => "active",
      default       => $bahmni_server_type
}

# Machines
$primary_machine_ip = "192.168.0.152"
$secondary_machine_ip = "192.168.0.115"

$primary_machine_host_name = "jssemr01"
$primary_machine_alias = "emr01.gan.jssbilaspur.org"

$secondary_machine_host_name = "jssemr02"
$secondary_machine_alias = "emr02.gan.jssbilaspur.org"

# mysql
$mysqlRootPassword = "password"

## Postgres
$postgresMajorVersion ="9"
$postgresMinorVersion = "2"
$postgresUser="postgres"

$postgresMachine = $install_server_type ? {
  "active"  => "master",
  undef     => "master",
  "passive" => "slave"
}

$postgresMaster = $primary_machine_ip
$postgresSlave = $secondary_machine_ip

$postgresFirstTimeSetup=true # Use this for first time setup of master and slave
$postgresMasterDbFileBackup="/tmp/pg_master_db_file_backup.tar" # The path of master db backup tar file on slave

#Postgres calculated variables
$postgresServiceName = "postgresql-${postgresMajorVersion}.${postgresMinorVersion}"
$postgresDataFolder = "/var/lib/pgsql/${postgresMajorVersion}.${postgresMinorVersion}/data"

#Go Server for Downloading Builds
$build_source = $build_source_dir ? {
      undef			=> "http://172.18.2.11:8153",
      default       => $build_source_dir
}

$go_server_user = "guest"
$go_server_pwd = "p@ssw0rd"
$artifacts_go_build_name = "Latest"
$config_go_build_name = "Latest"
$source_code_branch = "master"

#Tomcat 8
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
$httpd_log_directory="/var/log"

$bahmniAppsDirectory="${httpd_deploy_dir}/bahmniapps"
$bahmniConfigDirectory="${httpd_deploy_dir}/bahmni_config"
$bahmniRevisionsDirectory="${httpd_deploy_dir}/bahmni_revisions"

$uploadedFilesDirectory="${tomcatParentDirectory}/uploaded-files"

# Backup config
$backup_hour = 3 # 4 AM Every day

# Bahmni core properties
$patientImagesDirectory="/home/${bahmni_user}/patient_images"
$patientImagesUrl="/patient_images"
$documentBaseDirectory="/home/${bahmni_user}/document_images"
$uploadedResultsDirectory="/home/${bahmni_user}/uploaded_results"


######################## HTTPD CONFIG START#############################################
import "httpd-default-configuration"

## The following redirects can contain either a string or an array;
## If it is a string, the same is used for both ProxyPass and ProxyPassReverse rules;
## In case of array, 1st element of the array specifies ProxyPass rule and 2nd element specifies ProxyPassReverse rule.
$httpsRedirects = [{path => "/home", redirectPath => "/bahmni/home/"}]
$httpProxyRedirects = [{path => "/jasperserver", redirectPath => "http://localhost:8080/jasperserver"}]
$httpsProxyRedirects = [{path => "/openmrs", redirectPath => "http://localhost:8080/openmrs"},
                   {path => "/openelis", redirectPath => "http://localhost:8080/openelis"},
                   {path => "/reference-data", redirectPath => "http://localhost:8080/reference-data"}]
#Static webapps
$httpsStaticWebapps = [
					   {path => "/bahmni", directory => "${bahmniAppsDirectory}"},
					   {path => "${patientImagesUrl}", directory => "${patientImagesDirectory}"},
					   {path => "/document_images", directory => "${documentBaseDirectory}"},
                       {path => "/bahmni_config", directory => "${bahmniConfigDirectory}"},
                       {path => "/bahmni_revisions", directory => "${bahmniRevisionsDirectory}"},
                       {path => "/uploaded_results", directory => "${uploadedResultsDirectory}"},
                       {path => "/uploaded-files", directory => "${uploadedFilesDirectory}"}]
$httpsCachedDirectories = []
$httpsAggressiveCacheDisabledDirectories = []
$httpsSubdomains = [{subdomain => "openerp", url => "http://localhost:8069"}]

$httpdCacheDirectory = "/var/cache/mod_proxy"
$httpsCacheUrls = [{path => "${patientImagesDirectory}", type => 'Directory', expireTime => "86400"}, #86400s => 1day
				   {path => "${documentBaseDirectory}", type => 'Directory', expireTime => "86400"},
				   {path => "${bahmniAppsDirectory}", type => 'Directory', expireTime => "1"}, #1s
 				   {path => "/openmrs/ws/rest/v1/concept"}]
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
$openelis_password="adminADMIN\!"

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

# Set the Jasper Reports URL to download from:
$report_zip_source_url = $implementation_name ? {
	  undef			 => "https://github.com/jss-emr/jss-reports/archive/master.zip",
      "jss"			 => "https://github.com/jss-emr/jss-reports/archive/master.zip",
      default        => "https://github.com/jss-emr/jss-reports/archive/master.zip",
      "search"       => "https://github.com/Bhamni/search-reports/archive/master.zip",
      "lokbiradari"  => "https://github.com/Bhamni/lokbiradari-reports/archive/master.zip",
      "possible"  => "https://github.com/Bhamni/possible-reports/archive/master.zip"
}

######################## JASPER CONFIG END##############################################

$ant_version="1.9.1"
$ant_home="/home/${bahmni_user}/apache-ant-${ant_version}"
