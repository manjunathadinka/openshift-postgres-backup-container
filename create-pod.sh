#!/bin/bash -x

# This script is a utility script to create a pod in openshift to
# run backups. The script loads all required environment variables from a file.
# These environment variables are passed to the pod and the backup scripts
# running witihn the pod.

# Tyrell Perera (tyrell.perera@gmail.com)

source conf/env-config.txt

echo "Running with these environment options"
set | grep PG
set | grep DUMPPREFIX
set | grep S3BUCKET
set | grep AWS

oc new-app tyrell/openshift-postgres-backup-container:latest \
    --name=postgres-backup-creation \
    -e PGHOST=${PGHOST} \
    -e PGPORT=${PGPORT} \
    -e PGUSER=${PGUSER} \
    -e PGPASSWORD=${PGPASSWORD} \
    -e DUMPPREFIX=${DUMPPREFIX} \
    -e S3BUCKET=${S3BUCKET} \
    -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
    -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
    -e AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}

oc volume dc/postgres-backup-creation --add \
    --type=persistentVolumeClaim \
    --claim-size=1Gi \
    --mount-path=/backups \
    --name=backups
