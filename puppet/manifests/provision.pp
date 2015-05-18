import "configurations/stack-installers-configuration"
import "configurations/constants"

node default {
  notice "$server_type"
  include "nodes::$server_type"
}