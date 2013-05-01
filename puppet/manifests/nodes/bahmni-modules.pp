class { users : userName => "${bahmni_user}", password => "${bahmni_user_password}" }
class { ant: require => Class["users"]}
include openmrs