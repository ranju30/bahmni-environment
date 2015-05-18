import "configurations/stack-installers-configuration"

stage { 'first_stage' : before => Stage['main'] }

node default {
  
  require global
  
  class { 'yum_repo': stage => 'first_stage' }
  class { 'selinux': stage => 'first_stage' }
  include host
  include tools
  include java
  include mysql_client

  class { 'users' : userName => "${::global::runtime::bahmni_user}", password_hash => "${bahmni_user_password_hash}" }

  include cron_tab

}