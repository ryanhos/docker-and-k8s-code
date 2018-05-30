#!/usr/bin/env bash

if [ -z "${PROJECT}" ]; then
    PROJECT=${GOOGLE_CLOUD_PROJECT}
fi

if [ -z "${ZONE}" ]; then
    ZONE=us-central1-a
fi

if [ -z "${1}" ]; then
    echo "Please provide username (no domain) as first argument"
    exit 1
fi

USER_SLUG=${1//_/-}

gcloud beta container --project "${PROJECT}" clusters create "${USER_SLUG}" --zone "${ZONE}" \
--username "admin" --cluster-version "1.8.10-gke.0" --machine-type "n1-standard-2" --image-type "COS" \
--disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
--num-nodes "1" --enable-cloud-logging --enable-cloud-monitoring --network "default" --subnetwork "default" \
--addons HorizontalPodAutoscaling --enable-autorepair --async
