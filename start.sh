#!/bin/bash

# This script will set up the environment
# based on the environment variables passed to the docker container

# Tyrell Perera (tyrell.perera@gmail.com)


# Check if each var is declared and if not,
# set a sensible default

if [ -z "${PGUSER}" ]; then
  PGUSER=docker
fi

if [ -z "${PGPASSWORD}" ]; then
  PGPASSWORD=docker
fi

if [ -z "${PGPORT}" ]; then
  PGPORT=5432
fi

if [ -z "${PGHOST}" ]; then
  echo "Host name of the PostgreSQL database is not set. Can not continue."
  exit 1
fi

if [ -z "${DUMPPREFIX}" ]; then
  DUMPPREFIX=PG
fi

if [ -z "${S3BUCKET}" ]; then
  echo "S3 Bucket Location is not set. Can not continue."
  exit 1
fi

if [ -z "${AWS_ACCESS_KEY_ID}" ]; then
  echo "AWS_ACCESS_KEY_ID is not set. Can not continue."
  exit 1
fi

if [ -z "${AWS_SECRET_ACCESS_KEY}" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not set. Can not continue."
  exit 1
fi

if [ -z "${AWS_DEFAULT_REGION}" ]; then
  echo "AWS_DEFAULT_REGION is not set. Using Sydney as the AWS default region."
  AWS_DEFAULT_REGION=ap-southeast-2
fi

# Now write these all to case file that can be sourced
# by the cron job - we need to do this because
# env vars passed to docker will not be available
# in the context of the running cron script.
echo "
export PGUSER=$PGUSER
export PGPASSWORD=$PGPASSWORD
export PGPORT=$PGPORT
export PGHOST=$PGHOST
export DUMPPREFIX=$DUMPPREFIX
export S3BUCKET=$S3BUCKET
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
 " > /pgenv.sh

echo "Start script running with these environment options"
set | grep PG

# Now launch cron in the foreground.
cron -f
