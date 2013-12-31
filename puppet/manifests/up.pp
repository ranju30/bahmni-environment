import "configurations/node-configuration"
import "configurations/stack-installers-configuration"
import "configurations/stack-runtime-configuration"
import "configurations/deployment-configuration"

# pre-condition
# Tomcat should be stopped
node default {
  class {"bahmni-service" :
    status => "running",
    tomcat_status => "start"
  }
}