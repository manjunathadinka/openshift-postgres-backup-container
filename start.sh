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
  PGHOST=db
fi

if [ -z "${PGDATABASE}" ]; then
  PGDATABASE=gis
fi

if [ -z "${DUMPPREFIX}" ]; then
  DUMPPREFIX=PG
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
export PGDATABASE=$PGDATABASE
export DUMPPREFIX=$DUMPPREFIX
 " > /pgenv.sh

echo "Start script running with these environment options"
set | grep PG

# Now launch cron in the foreground.

cron -f
