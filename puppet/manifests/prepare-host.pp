import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"

stage { 'first_stage' : before => Stage['main'] }

node default {

  class { 'yum_repo': stage => 'first_stage' }
  class { 'selinux': stage => 'first_stage' }
  include host
  include tools
  include java
  include mysql

  class { 'users' : userName => "${bahmni_user}", password_hash => "${bahmni_user_password_hash}" }

  include cron_tab

}