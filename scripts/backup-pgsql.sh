#!/bin/bash

set -e

TIME=`date +%Y%m%d_%H%M%S`
BACKUP_DIR=${1:-/backup}

pg_dumpall -U postgres | gzip -c > ${BACKUP_DIR}/pgsql_backup_$TIME.sql.gz