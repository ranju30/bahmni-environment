class bahmni_openerp_basedata::config inherits global {
  $os_path="${::global::os_path}"
  $bahmni_user="${::global::bahmni_user}"
  $temp_dir = "${::global::temp_dir}"
}