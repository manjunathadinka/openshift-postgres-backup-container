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
set | grep S3_BUCKET
set | grep AWS

oc create -f - <<EOF
    #cat <<EOF
apiVersion: v1
kind: Pod
metadata:
  generateName: backup-postgres
spec:
  containers:
  - image: tyrell/openshift-postgres-backup-container:latest
    imagePullPolicy: Always
    name: backup
    volumeMounts:
    - name: empty
      mountPath: /data
    env:
      - name: PGHOST
        value: ${PGHOST}
      - name: PGPORT
        value: ${PGPORT}
      - name: PGUSER
        value: ${PGUSER}
      - name: PGPASSWORD
        value: ${PGPASSWORD}
      - name: DUMPPREFIX
        value: ${DUMPPREFIX}
      - name: S3_BUCKET
        value: ${S3_BUCKET}
      - name: AWS_ACCESS_KEY_ID
        value: ${AWS_ACCESS_KEY_ID}
      - name: AWS_SECRET_ACCESS_KEY
        value: ${AWS_SECRET_ACCESS_KEY}
      - name: AWS_DEFAULT_REGION
        value: ${AWS_DEFAULT_REGION}
  dnsPolicy: ClusterFirst
  nodeSelector:
    role: infra
  restartPolicy: Never
  volumes:
  - name: empty
    emptyDir: {}
EOF
