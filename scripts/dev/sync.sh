#!/bin/sh
if [ $# -lt 3 ]; then
   echo "Usage: $0 <local_folder> <remote_ip> <remote_folder>"
   echo "Eg: scripts/dev/sync.sh ../registration/app/ 10.4.33.25 /var/www/registration"
   exit 1
fi

local=$1
remote=$2
path=$3
sync_command="date +%H:%M:%S && rsync -iru --exclude .git --exclude target --progress --itemize-changes --update --delete -p $local -e ssh root@$remote:$path"
sh -c "$sync_command"
fswatch $local "$sync_command"
