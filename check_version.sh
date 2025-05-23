#!/bin/bash

headers='-H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28"'
# if GITHUB_TOKEN exists create auth header
if [[ -n "$GITHUB_TOKEN" ]]; then
    headers="$headers -H \"Authorization Bearer $GITHUB_TOKEN\""
fi

FILES="${FILES:-"$@"}"
IGNORE_VERSION_REGEX="${IGNORE_VERSION_REGEX:-main|master|latest}"

# if Use_error is set to true use error instead of warning
if [[ "$USE_ERROR" == "true" ]]; then
    MSG="error"
else
    MSG="warning"
fi

# Process the list of actions without using a subshell
outdated_found=false
while IFS= read -r action; do
    action_name="$(echo "$action" | cut -d'@' -f1)"
    action_version="$(echo "$action" | cut -d'@' -f2)"

    # Check if action_version is empty or matches the ignore regex
    if [[ -z "$action_version" || "$action_version" =~ $IGNORE_VERSION_REGEX ]]; then
        echo "::debug::Ignoring action $action_name with version $action_version"
        continue
    fi

    if [[ "$action_name" == *"/"* ]]; then
        # Get the latest version from the GitHub API
        latest_version="$(curl -Ls "$headers" "https://api.github.com/repos/$action_name/releases/latest" | jq -r '.tag_name')"

        # Check if latest version begins with action_version
        if [[ "$latest_version." == "$action_version."* ]]; then
            echo "::debug::Action $action_name is up to date. Current version: $action_version, Latest version: $latest_version"
        else
            echo "::$MSG title=$action_name is outdated::Current version: $action_version, Latest version: $latest_version"
            outdated_found=true
        fi
    fi
    # Use process substitution to avoid subshell
done < <(echo "$FILES" | xargs -n 1 grep -hrPo '\s+uses:\s+\K(.*)' --include '*.yml' --include '*.yaml' | sort -u)

if [[ "$USE_ERROR" == "true" && "$outdated_found" == "true" ]]; then
    echo "::error::Some actions are outdated. Please update them."
    exit 1
fi
