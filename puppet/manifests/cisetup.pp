import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"
import "configurations/cisetup-configuration"


node default {

  stage { "first" : }
  stage { "last" : }
  stage { "deploy" : }

  Stage['first'] -> Stage['main']
  Stage['main'] -> Stage['deploy']
  Stage['deploy'] -> Stage['last']

  class { "bootstrap": stage => 'first'; }
  class { "yum-repo":  stage => 'first'; }
  class { "host":      stage => 'first'; }
  class { "users":
       stage         => "first",
       userName      => "${bahmni_user}", 
       password_hash => "${bahmni_user_password_hash}"
  }
  

  include tools
  include java    
  include mysql
  include mysqlserver
  include tomcat
  include httpd
  include jasperserver
  include python
  include postgresql
  include openerp

  class { "openmrs" : stage => "deploy"; }
  class { "bahmni-configuration" : stage => "deploy"; }
  class { "bahmni-webapps" : stage => "deploy"; }
  class { "bahmni-data" : stage => "deploy"; }
  class { "bahmni-openerp" : stage => "deploy"; }
  class { "registration" : stage => "deploy"; }

  class { "nodejs": stage => "last", version => '0.8.19'; }
  class { "bahmni-openerp-basedata" : stage => "last"; }
  class { "maven" : stage => "last"; }
  class { "ci-tools" : stage => "last"; }
  class { "go-setup" : stage => "last"; }
}

