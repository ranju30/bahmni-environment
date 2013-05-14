import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"

node default {
	package { "libjpeg-turbo" : ensure => present, provider => yum}
}