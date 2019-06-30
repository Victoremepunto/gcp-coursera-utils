#!/bin/bash

PROJECT_ID=$1
DATA_DIR=$2

if [ -z "$PROJECT_ID" ]; then
    echo "please specify project ID"
    exit 1
fi

createGcpTrainingContainer() {

    CONTAINER_NAME="$1"

    echo "docker container doesn't exist, creating ..."
    docker run -ti --name "$CONTAINER_NAME" google/cloud-sdk bash -c "gcloud auth login && gcloud config set project $CONTAINER_NAME"
}

[ ! "$(docker ps -a | grep "$PROJECT_ID")" ] && createGcpTrainingContainer "$PROJECT_ID"

if [ -z "$DATA_DIR" ]; then
    docker run --rm -ti --volumes-from "$PROJECT_ID" -e "PROJECT_ID=$PROJECT_ID" google/cloud-sdk 
else
    docker run --rm -ti --volumes-from "$PROJECT_ID" -e "PROJECT_ID=$PROJECT_ID" -v "$(realpath $DATA_DIR):/data" google/cloud-sdk 
fi
