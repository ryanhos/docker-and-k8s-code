#!/usr/bin/env bash

docker build --build-arg COMMIT_SHA=df57d9d -t github-pr-dashboard .

gcloud auth configure-docker

docker tag github-pr-dashboard:latest us.gcr.io/round-ring-181705/github-pr-dashboard:latest

docker push us.gcr.io/round-ring-181705/github-pr-dashboard:latest
