### An Openshift compatible container to backup a PostgreSQL database to S3

This project contains a Docker image that can be deployed to an Openshift project in order to create periodic backups of all databases within a PostgreSQL pod to an S3 bucket.

A public Docker image is hosted at https://hub.docker.com/r/tyrell/openshift-postgres-backup-container/ 

## Deploying the container using the public image

  1. Clone this repository
  2. Change the conf/env-config.txt and fill in the mandatory environment variables. 
  3. run the create-pod.sh bash script.
  
## Building the Docker image yourself and hosting it

  1. Clone this repository.
  2. Build the Docker image.
  
    ` docker build -t <your-docker-repo>/openshift-postgres-backup-container .
    
  3. Deploy the image to your repository 
  
    ` docker push <your-docker-repo>/openshift-postgres-backup-container:latest
    
  4. Change the conf/env-config.txt and fill in the mandatory environment variables. 
  5. Change the create-pod.sh bash script to pick your image from <your-docker-repo>/openshift-postgres-backup-container:latest
  6. run the create-pod.sh bash script.

## License
Copyright (c) 2017 Tyrell Perera <tyrell.perera@gmail.com>
Licensed under the MIT license.
