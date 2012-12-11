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
 $mysqlPassword = "password"

 #Tomcat 7.0.22 configuration

 $tomcatManagerPassword = "p@ssw0rd"

 ## optional
 $tomcatManagerUserName = "tomcat"
 $tomcatHttpPort="8080"
 $tomcatRedirectPort="8443"
 $tomcatShutdownPort="8005"
 $tomcatAjpPort="8009"


 #--------------------------------RESOURCES--------------------------------------------
 # comment out resources not required to be installed

 # class {users : userName => "${jssUser}", password => "${jssPassword}" }
 # class {tomcat : version => "7.0.22", userName => "${jssUser}", tomcatManagerUserName => "${tomcatManagerUserName}", tomcatManagerPassword => "${tomcatManagerPassword}", tomcatHttpPort => "${tomcatHttpPort}", tomcatRedirectPort => "${tomcatRedirectPort}", tomcatShutdownPort => "${tomcatShutdownPort}", tomcatAjpPort => "${tomcatAjpPort}"}
 # include mysql
 # include mysqlserver
 # include tomcat
