class implementation-config($implementation_name = $implementation_name) {
  class {"implementation-config::openmrs": implementation_name => "$implementation_name"}
  class {"implementation-config::openerp": implementation_name => "$implementation_name"}
  class {"implementation-config::openelis": implementation_name => "$implementation_name"}
}