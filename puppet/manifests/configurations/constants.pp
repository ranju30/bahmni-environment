# user
# to generate password hash use 'echo "password" | openssl passwd -1 -stdin'

$bahmni_release_version="5.6-SNAPSHOT"

$bahmni_user_password_hash = '$1$IW4OvlrH$Kui/55oif8W3VZIrnX6jL1' #p@ssw0rd
$ssh_port=22

# mysql
$mysqlRootPassword = "password"

## Postgres
$postgresMajorVersion ="9"
$postgresMinorVersion = "2"
$postgresUser="postgres"

$postgresFirstTimeSetup=true # Use this for first time setup of master and slave
$postgresMasterDbFileBackup="/tmp/pg_master_db_file_backup.tar" # The path of master db backup tar file on slave

#Postgres calculated variables
$postgresServiceName = "postgresql-${postgresMajorVersion}.${postgresMinorVersion}"
$postgresDataFolder = "/var/lib/pgsql/${postgresMajorVersion}.${postgresMinorVersion}/data"


#Tomcat 8
$tomcatManagerUserName = "tomcat"
$tomcatManagerPassword = "p@ssw0rd"
$tomcatHttpPort="8080"
$tomcatRedirectPort="8443"
$tomcatShutdownPort="8005"
$tomcatAjpPort="8009"
$tomcatSessionTimeoutInMinutes = 120

# Set host name or ip address
$httpd_deploy_dir="/var/www"
$httpd_log_directory="/var/log"

$bahmniAppsDirectory="${httpd_deploy_dir}/bahmniapps"
$bahmniConfigDirectory="${httpd_deploy_dir}/bahmni_config"
$bahmniRevisionsDirectory="${httpd_deploy_dir}/bahmni_revisions"

$smtp_host="gmail-smtp-in.l.google.com"
$from_email="bahmni@gmail.com"

$openerpGroup = "openerp"
$client_side_logging = "client_side_logging"
$jasperHome = "/usr/local/jasperreports-server-cp-5.0.0-bin"
