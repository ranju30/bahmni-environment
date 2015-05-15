import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"
import "configurations/runtime/*"

node default {
  include httpd
  include artifactory
}