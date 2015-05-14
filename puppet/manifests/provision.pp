import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"

node default {
  notice "$server_type"
  include "nodes::$server_type"
}