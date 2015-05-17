import "configurations/stack-installers-configuration"
import "configurations/runtime/*"
import "configurations/constants"

node default {
  notice "$server_type"
  include "nodes::$server_type"
}