rootPassword=$1
souceIP=$2

SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR

BACKUP_DIR=${3:-/backup}

if [ -z $rootPassword ]; then
    echo "Please provide a password for mysql root"
    echo "[USAGE] $0 <mysqlRootPassword> [sourceHostIP] [BACKUP_DIR]"
    exit 1
fi

if [ -z $souceIP ]; then
    echo "No source Host IP provided. Using 127.0.0.1"
    souceIP=127.0.0.1
    echo "[USAGE] $0 <mysqlRootPassword> [sourceHostIP] [BACKUP_DIR]"
fi


TIME=`date +%Y%m%d_%H%M%S`
OPENMRS_NEW_DB=anonymised_openmrs_$TIME
OPENELIS_NEW_DB=anonymised_clinlims_$TIME
OPENERP_NEW_DB=anonymised_openerp_$TIME

# Take dump & restore on a different temp database.
mysql -uroot -p$rootPassword -e "create database $OPENMRS_NEW_DB"
mysqldump --routines --no-create-db openmrs --single-transaction --compress --order-by-primary --host $souceIP -uroot -p$rootPassword | mysql -uroot -p$rootPassword $OPENMRS_NEW_DB

psql -Upostgres -c "create database $OPENELIS_NEW_DB";
/usr/pgsql-9.2/bin/pg_dump -h $souceIP -Uclinlims clinlims | psql -Upostgres $OPENELIS_NEW_DB

psql -Upostgres -c "create database $OPENERP_NEW_DB";
/usr/pgsql-9.2/bin/pg_dump -h $souceIP -Upostgres openerp | psql -Upostgres $OPENERP_NEW_DB

# Anonymise
sh ./bahmni-tools/anonymise-lite/anonymise.sh $OPENMRS_NEW_DB $OPENELIS_NEW_DB $OPENERP_NEW_DB

# Take dump of anonymised DB
mysqldump --routines --no-create-db $OPENMRS_NEW_DB --single-transaction --compress --order-by-primary -uroot -p$rootPassword | gzip -c > $BACKUP_DIR/$OPENMRS_NEW_DB.sql.gz
/usr/pgsql-9.2/bin/pg_dump -Upostgres $OPENELIS_NEW_DB | gzip -c > $BACKUP_DIR/$OPENELIS_NEW_DB.sql.gz
/usr/pgsql-9.2/bin/pg_dump -Upostgres $OPENERP_NEW_DB | gzip -c > $BACKUP_DIR/$OPENERP_NEW_DB.sql.gz


# Drop Temp Databases
mysql -uroot -p$rootPassword -e "drop database $OPENMRS_NEW_DB"
psql -Upostgres -c "drop database $OPENELIS_NEW_DB"
psql -Upostgres -c "drop database $OPENERP_NEW_DB"
