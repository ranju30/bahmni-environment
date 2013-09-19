#!/bin/bash

set -e -x

TIME=`date +%Y%m%d_%H%M%S`
su - postgres -c "pg_dumpall | gzip -c > /backup/pgsql_backup_$TIME.sql.gz"