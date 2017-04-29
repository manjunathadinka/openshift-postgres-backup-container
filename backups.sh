#!/bin/bash

# This script will be periodically executed by the cron job. The script will
# backup all databases in the postgres server into an AWS S3 bucket.

# Tyrell Perera (tyrell.perera@gmail.com)

source /pgenv.sh

echo "Running with these environment options" >> /var/log/cron.log
set | grep PG >> /var/log/cron.log

MYDATE=`date +%d-%B-%Y`
MONTH=$(date +%B)
YEAR=$(date +%Y)
MYBASEDIR=/backups
MYBACKUPDIR=${MYBASEDIR}/${YEAR}/${MONTH}
mkdir -p ${MYBACKUPDIR}
cd ${MYBACKUPDIR}

echo "Backup running to $MYBACKUPDIR" >> /var/log/cron.log

#
# Loop through each postgres database and back it up to S3.
#
DBLIST=`psql -h $PGHOST -U $PGUSER --no-password -l | awk '{print $1}' | grep -v "+" | grep -v "Name" | grep -v "List" | grep -v "(" | grep -v "template" | grep -v "postgres" | grep -v "|" | grep -v ":"`
echo "Databases to backup: ${DBLIST}" >> /var/log/cron.log
for DB in ${DBLIST}
do
  echo "Backing up $DB"  >> /var/log/cron.log
  FILENAME=${DUMPPREFIX}_${DB}.${MYDATE}.gz
  FILEPATH=${MYBACKUPDIR}/${FILENAME}
  FORMAT='sql.gz'
  pg_dump -x -h $PGHOST -U $PGUSER --no-password -d $DB | gzip > $FILEPATH

  echo "Uploading $FILEPATH to S3 at s3://$S3BUCKET/$FILENAME"
  aws s3 cp ${FILEPATH} s3://${S3BUCKET}/${FILENAME}
done
