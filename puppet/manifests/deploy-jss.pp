import "deploy-jss-bahmni-openmrs.pp"

node deploy-jss {
  include deploy-jss-bahmni-openmrs
  include bahmni-openerp
  include openelis
}