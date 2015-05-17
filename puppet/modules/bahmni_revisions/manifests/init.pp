class bahmni_revisions inherits bahmni_revisions::config {
  include  httpd

  file {"${bahmniRevisionsDirectory}" :
    ensure      => directory,
    owner       => "${::config::bahmni_user}",
    group       => "${::config::bahmni_user}",
    mode        => 755
  }

  exec { "copy_bahmni_revision_files" :
    command     => "cp ${::config::build_output_dir}/bahmni_*_revision.txt ${bahmniRevisionsDirectory}",
    path        => "${config::os_path}",
    require     => [File["${bahmniRevisionsDirectory}"]]
  }
}
