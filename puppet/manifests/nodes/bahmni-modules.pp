class {users : userName => "${jssUser}", password => "${jssPassword}" }
class { ant: require => Class["users"]}
class { jasperserver : require => Class["tomcat"], userName => "${jssUser}"}
include phantom-jasmine
include openerp