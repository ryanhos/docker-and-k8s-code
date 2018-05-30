#!/bin/bash
##########################
## Web dashboard for GitHub pull requests
##
## Environment Variables
## DASHBOARD_NAME: Dashboard name displayed in page header
## REPOSITORY_NAMES: Space-separated repository identifiers. E.g. project/repo1 project/repo2
## GROUP_BY_REPO: true/false to group PRs by repository in the display
## GITHUB_TOKEN: Token with permission to read private repos
##
##########################


##########################
# Functions
##########################
function one_time_setup {
	local repo_string

	if [[ -z ${GITHUB_TOKEN+x} && -f "${github_secret_file}" ]]; then
		GITHUB_TOKEN=`cat "${github_secret_file}"`
	fi

	for repo in $REPOSITORY_NAMES
	do
		repo_string="${repo_string} \"${repo}\","
	done
	repo_string=${repo_string: 0 : ${#repo_string} - 1 }  #Strip last comma

	jq_filter=".title = \"${DASHBOARD_NAME}\" | .token = \"${GITHUB_TOKEN}\" | .groupByRepo = ${GROUP_BY_REPO} | .repos = [ ${repo_string} ]"

	cat config/config.json.template | jq "${jq_filter}" > "${config_json}"
}

##########################
# Main script
##########################
config_json=config/config.json
github_secret_file=/run/github_token

if [[ ! -f "${config_json}" ]] ; then
	one_time_setup
fi

node server/index.js
