class jss-cron {

    cron { "sync_patient_image_cron" :
        command => "rsync -rh --progress -i --itemize-changes --update --delete --chmod=Du=r,Dg=rwx,Do=rwx,Fu=rwx,Fg=rwx,Fo=rwx -p ${imagesDirectory} -e ssh root@${secondary_machine_ip}:${imagesDirectory}/../",
        user    => "root",
        minute  => "*/1"
    }
}