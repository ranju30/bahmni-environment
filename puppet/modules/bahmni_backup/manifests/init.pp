class bahmni_backup inherits bahmni_backup::config {
    
    exec { "create_patient_images_dir_on_secondary_machine":
        command => "ssh root@${config::passive_app_server} 'mkdir -p ${config::patientImagesDirectory}'",
        path        => "${config::os_path}",
    }

    #--delete option is taken out from rsync intentionally. As slave folder acts as backup.
    cron { "sync_patient_image_cron" :
        command => "rsync -rh --progress -i --itemize-changes --update --chmod=Du=r,Dg=rwx,Do=rwx,Fu=rwx,Fg=rwx,Fo=rwx -p ${config::patientImagesDirectory} -e ssh root@${config::passive_app_server}:${config::patientImagesDirectory}/../",
        user    => "root",
        minute  => "*/1"
    }

    exec { "create_document_images_dir_on_secondary_machine":
        command => "ssh root@${config::passive_app_server} 'mkdir -p ${config::documentBaseDirectory}'",
        path        => "${config::os_path}",
    }

	cron { "sync_document_image_cron" :
		command => "rsync -rh --progress -i --itemize-changes --update --delete --chmod=Du=r,Dg=rwx,Do=rwx,Fu=rwx,Fg=rwx,Fo=rwx -p ${config::documentBaseDirectory} -e ssh root@${config::passive_app_server}:${config::patientImagesDirectory}/../",
		user    => "root",
		minute  => "*/1"
	}
}