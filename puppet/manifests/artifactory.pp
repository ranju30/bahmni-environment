import "configurations/stack-installers-configuration"
import "configurations/runtime/*"

node default {
  include httpd
  include artifactory
}