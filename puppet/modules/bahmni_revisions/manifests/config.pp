class bahmni_revisions::config inherits global {
  $os_path="${::global::os_path}"
  $bahmni_user="${::global::bahmni_user}"
  $build_output_dir = "${::global::build_output_dir}"
}