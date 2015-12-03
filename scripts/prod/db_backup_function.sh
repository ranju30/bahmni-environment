#!/bin/bash

function all_dbs_backup() {
    BACKUP_PATH=$1
    if [ ! -d "$BACKUP_PATH" ]; then
        echo "Attempting to create backup folder: $BACKUP_PATH"
        sudo mkdir -pv $BACKUP_PATH
    fi

    TIME=`date +%Y%m%d_%H%M%S`

    # Perform backup of MYSQL DB
    # sudo mysqldump -uroot -ppassword --all-databases --routines | gzip > $BACKUP_PATH/mysql_backup_$TIME.sql.gz

    # Perform backup of PostgreSQL DB
    # chown postgres:postgres $BACKUP_PATH
    # su - postgres -c "pg_dumpall | gzip -c > $BACKUP_PATH/pgsql_backup_$TIME.sql.gz"
}


