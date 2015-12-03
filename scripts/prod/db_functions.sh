#!/bin/bash

MYSQL_PASSWORD=password
function all_dbs_backup() {
    BACKUP_PATH=$1
    if [ ! -d "$BACKUP_PATH" ]; then
        echo "Attempting to create backup folder: $BACKUP_PATH"
        sudo mkdir -pv $BACKUP_PATH
    fi

    TIME=`date +%Y%m%d_%H%M%S`

    # Perform backup of MYSQL DB
    sudo mysqldump -uroot -p$MYSQL_PASSWORD --all-databases --routines | gzip > $BACKUP_PATH/mysql_backup_$TIME.sql.gz

    # Perform backup of PostgreSQL DB
    chown postgres:postgres $BACKUP_PATH
    su - postgres -c "pg_dumpall | gzip -c > $BACKUP_PATH/pgsql_backup_$TIME.sql.gz"
}

function get_failed_events_log() {
    rm -f /tmp/failed_events_openmrs.csv
    rm -f /tmp/failed_events_openelis.csv
    rm -f /tmp/failed_events_openerp.csv
    mysql -uroot -p$MYSQL_PASSWORD openmrs -e "SELECT * INTO OUTFILE '/tmp/failed_events_openmrs.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' from failed_events;" > /dev/null
    echo -e "$green Openmrs $original failed events copied"
    psql -Upostgres clinlims -c "COPY (select * from clinlims.failed_events) to '/tmp/failed_events_openelis.csv' (format csv, delimiter ',');" > /dev/null
    echo -e "$green Openelis $original failed events copied"
    psql -Upostgres openerp -c "COPY (select * from failed_events) to '/tmp/failed_events_openerp.csv' (format csv, delimiter ',');" > /dev/null
    echo -e "$green Openerp $original failed events copied"
}

function reset_retry_count() {
    mysql -uroot -p$MYSQL_PASSWORD openmrs -e "UPDATE failed_events set retries=0;" > /dev/null
    echo -e "$green Openmrs $original failed events retry count resetted"

    psql -Upostgres clinlims -c "UPDATE clinlims.failed_events set retries=0;" > /dev/null
    echo -e "$green Openelis $original failed events retry count resetted"

    psql -Upostgres openerp -c "UPDATE failed_events set retries=0;" > /dev/null
    echo -e "$green Openerp $original failed events retry count resetted"
}