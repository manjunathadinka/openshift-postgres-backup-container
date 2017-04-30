#!/bin/bash

# This script will be periodically executed by the cron job. The script will
# backup all databases in the postgres server into an AWS S3 bucket.

# Tyrell Perera (tyrell.perera@gmail.com)

echo "Running with these environment options"
set | grep PG

MYDATE=`date +%d-%B-%Y`
MONTH=$(date +%B)
YEAR=$(date +%Y)
MYBASEDIR=/backups
MYBACKUPDIR=${MYBASEDIR}/${YEAR}/${MONTH}
mkdir -p ${MYBACKUPDIR}
cd ${MYBACKUPDIR}

echo "Backup running to $MYBACKUPDIR"
#
# Loop through each postgres database and back it up to S3.
#
DBLIST=`psql -h $PGHOST -U $PGUSER --no-password -l | awk '{print $1}' | grep -v "+" | grep -v "Name" | grep -v "List" | grep -v "(" | grep -v "template" | grep -v "postgres" | grep -v "|" | grep -v ":"`
echo "Databases to backup: ${DBLIST}"
for DB in ${DBLIST}
do
  echo "Backing up $DB"
  FILENAME=${DUMPPREFIX}_${DB}.${MYDATE}.gz
  FILEPATH=${MYBACKUPDIR}/${FILENAME}
  FORMAT='sql.gz'
  pg_dump -x -h $PGHOST -U $PGUSER --no-password $DB | gzip > $FILEPATH

  echo "Uploading $FILEPATH to S3 at s3://$S3BUCKET/$FILENAME"
  aws s3 cp ${FILEPATH} s3://${S3BUCKET}/${FILENAME}
  echo "Upload to S3 complete for $FILEPATH"
done

echo "Cleaning up local files at $MYBACKUPDIR ..."
rm -rf *.*
