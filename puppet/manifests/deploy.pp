import "configurations/stack-installers-configuration"
import "configurations/openmrs-versions-configuration.pp"

node default {
    require global
    if "${::config::implementation_name}" {
        class { "bahmni": } -> class { "implementation_config" : }
    } else {
        warning("implementation_name not set! not deploying implementation config")
        class { "bahmni": }
    }
}