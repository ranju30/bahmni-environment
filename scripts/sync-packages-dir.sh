# It would sync the bahmni-environment/packages directory to /packages on the dest machine.
# Pass the IP address of the destination machine 
rsync -rh --progress -i --itemize-changes --ignore-existing --delete --perms packages -e ssh root@$1:/