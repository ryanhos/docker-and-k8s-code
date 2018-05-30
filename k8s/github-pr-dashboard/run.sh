#!/usr/bin/env bash

docker run -d --env DASHBOARD_NAME=Dashboard --env "REPOSITORY_NAMES=kubernetes/ingress-nginx kubernetes/examples" \
	--env GROUP_BY_REPO=false --env GITHUB_TOKEN=some_token -p 8080:8080 github-pr-dashboard:latest
