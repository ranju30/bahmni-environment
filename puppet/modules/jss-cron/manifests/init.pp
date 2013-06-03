class jss-cron {
    #--delete option is taken out from rsync intentionally. As slave folder acts as backup.
    cron { "sync_patient_image_cron" :
        command => "rsync -avz --progress --update -i --itemize-changes -p ${imagesDirectory} -e ssh root@${secondary_machine_ip}:${imagesDirectory}/../",
        user    => "root",
        minute  => "*/1"
    }
}