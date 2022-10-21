#!/bin/bash
set -e

if [[ "$@" == "bash" ]]; then
    exec $@
fi

# Validations
if [[ -z $RUNNER_NAME ]]; then
    echo -e "\033[1;33mwarning: missing 'RUNNER_NAME' environment variable, using '${HOSTNAME}'.\033[0m"
    export RUNNER_NAME=${HOSTNAME}
fi

if [[ -z $RUNNER_WORK_DIRECTORY ]]; then
    echo -e "\033[1;33mwarning: missing 'RUNNER_WORK_DIRECTORY' environment variable, using '_work'.\033[0m"
    export RUNNER_WORK_DIRECTORY="_work"
fi

if [ -z "$RUNNER_TOKEN_FILE" ]; then
    if [[ -z $GITHUB_PERSONAL_ACCESS_TOKEN ]]; then
        echo 1>&2 "error: missing 'GITHUB_PERSONAL_ACCESS_TOKEN' environment variable."
        exit 1
    fi

    RUNNER_TOKEN_FILE=./.token
    echo -n $GITHUB_PERSONAL_ACCESS_TOKEN >"$RUNNER_TOKEN_FILE"

    unset GITHUB_PERSONAL_ACCESS_TOKEN

fi

if [[ -z $RUNNER_REPOSITORY_URL && -z $RUNNER_ORGANIZATION_URL ]]; then
    echo 1>&2 "error: missing 'RUNNER_REPOSITORY_URL' (or 'RUNNER_ORGANIZATION_URL') environment variable."
    exit 1
fi

if [[ -z $RUNNER_REPLACE_EXISTING ]]; then
    export RUNNER_REPLACE_EXISTING="true"
fi

# Set arguments
CONFIG_OPTS=""
if [ "$(echo $RUNNER_REPLACE_EXISTING | tr '[:upper:]' '[:lower:]')" == "true" ]; then
	CONFIG_OPTS="--replace"
fi

if [[ -n $RUNNER_LABELS ]]; then
    CONFIG_OPTS="${CONFIG_OPTS} --labels ${RUNNER_LABELS}"
fi

export AGENT_ALLOW_RUNASROOT="1"

# Let the agent ignore the token env variables
export VSO_AGENT_IGNORE=GITHUB_PERSONAL_ACCESS_TOKEN,RUNNER_TOKEN_FILE

if [[ -f ".runner" ]]; then
    echo "Runner already configured. Skipping config."
else
    if [[ ! -z $RUNNER_ORGANIZATION_URL ]]; then
        RUNNER_SCOPE="orgs"
        RUNNER_URL="${RUNNER_ORGANIZATION_URL}"
    else
        RUNNER_SCOPE="repos"
        RUNNER_URL="${RUNNER_REPOSITORY_URL}"
    fi

    if [[ -n $RUNNER_TOKEN_FILE ]]; then
        _PROTO="$(echo "${RUNNER_URL}" | grep :// | sed -e's,^\(.*://\).*,\1,g')"
        _URL="$(echo "${RUNNER_URL/${_PROTO}/}")"
        _PATH="$(echo "${_URL}" | grep / | cut -d/ -f2-)"

        RUNNER_TOKEN="$(curl -XPOST -fsSL \
            -H "Authorization: token $(cat ${RUNNER_TOKEN_FILE})" \
            -H "Accept: application/vnd.github.v3+json" \
            "https://api.github.com/${RUNNER_SCOPE}/${_PATH}/actions/runners/registration-token" \
            | jq -r '.token')"
    fi

    ./config.sh \
        --url $RUNNER_URL \
        --token $RUNNER_TOKEN \
        --name $RUNNER_NAME \
        --work $RUNNER_WORK_DIRECTORY \
        $CONFIG_OPTS \
        --unattended
fi

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --token ${RUNNER_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!