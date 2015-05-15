#HTTPD
class httpd::config {

  $sslEnabled = true
  $sslExcludeList = ["127.0.0.1"]
  $dropPacketsIfIPNotInSslExcludeList = false # true if the packets have to dropped when accessed over http

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

## Use property httpsProxyRedirects to setup proxypass redirects
  $authenticationExcludeHosts = []
  $authenticationExcludeUrlPatterns = []

######################## HTTPD CONFIG START#############################################

## The following redirects can contain either a string or an array;
## If it is a string, the same is used for both ProxyPass and ProxyPassReverse rules;
## In case of array, 1st element of the array specifies ProxyPass rule and 2nd element specifies ProxyPassReverse rule.
  $httpsRedirects = [{ path => "/home", redirectPath => "/bahmni/home/" }]
  $httpProxyRedirects = [{ path => "/jasperserver", redirectPath => "http://localhost:8080/jasperserver" }]
  $httpsProxyRedirects = [{ path => "/openmrs", redirectPath => "http://localhost:8080/openmrs" },
    { path => "/openelis", redirectPath => "http://localhost:8080/openelis" },
    { path => "/bahmnireports", redirectPath => "http://localhost:8080/bahmnireports" },
    { path => "/reference-data", redirectPath => "http://localhost:8080/reference-data" },
    { path => "/go", redirectPath => "http://localhost:8153/go" }]
#Static webapps
  $httpsStaticWebapps = [
    { path => "/bahmni", directory => "${bahmniAppsDirectory}" },
    { path => "${patientImagesUrl}", directory => "${patientImagesDirectory}" },
    { path => "/document_images", directory => "${documentBaseDirectory}" },
    { path => "/bahmni_config", directory => "${bahmniConfigDirectory}" },
    { path => "/bahmni_revisions", directory => "${bahmniRevisionsDirectory}" },
    { path => "/uploaded_results", directory => "${uploadedResultsDirectory}" },
    { path => "/uploaded-files", directory => "${uploadedFilesDirectory}" }]
  $httpsCachedDirectories = []
  $httpsAggressiveCacheDisabledDirectories = []
  $httpsSubdomains = [{ subdomain => "openerp", url => "http://localhost:8069" }]

  $httpdCacheDirectory = "/var/cache/mod_proxy"
  $httpsCacheUrls = [{ path => "${patientImagesDirectory}", type => 'Directory', expireTime => "86400" }, #86400s => 1day
    { path => "${documentBaseDirectory}", type => 'Directory', expireTime => "86400" },
    { path => "${bahmniAppsDirectory}", type => 'Directory', expireTime => "1" }, #1s
    { path => "/openmrs/ws/rest/v1/concept" }]
######################## HTTPD CONFIG END################################################
}
