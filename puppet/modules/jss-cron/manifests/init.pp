class jss-cron {
    #--delete option is taken out from rsync intentionally. As slave folder acts as backup.
    cron { "sync_patient_image_cron" :
        command => "rsync -rh --progress -i --itemize-changes --update --chmod=Du=r,Dg=rwx,Do=rwx,Fu=rwx,Fg=rwx,Fo=rwx -p ${imagesDirectory} -e ssh root@${secondary_machine_ip}:${imagesDirectory}/../",
        user    => "root",
        minute  => "*/1"
    }
}