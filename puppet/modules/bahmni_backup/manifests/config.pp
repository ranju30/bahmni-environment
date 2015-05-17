class bahmni_backup::config inherits global {
  $os_path="${::global::os_path}"
  $passive_app_server="${::global::passive_app_server}"
  $patientImagesDirectory="${::global::patientImagesDirectory}"
  $documentBaseDirectory="${::global::documentBaseDirectory}"
}