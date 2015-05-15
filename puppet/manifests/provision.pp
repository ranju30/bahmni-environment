import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"
import "configurations/runtime/*"
import "configurations/constants"

node default {
  notice "$server_type"
  include "nodes::$server_type"
}