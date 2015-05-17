class bahmni_configuration::config {
  $os_path="${::global::os_path}"
  $bahmni_user="${::global::bahmni_user}"
  $uploadedFilesDirectory="${::global::uploadedFilesDirectory}"
  $patientImagesDirectory="${::global::patientImagesDirectory}"
  $documentBaseDirectory="${::global::documentBaseDirectory}"
  $uploadedResultsDirectory="${::global::uploadedResultsDirectory}"
  $patientImagesUrl="${::global::patientImagesUrl}"
}