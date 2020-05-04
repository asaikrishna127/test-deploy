#!/usr/bin/env bash
set -e

BASE_VERSION=$(cat .version)
ARTIFACT_NAME=$(go mod edit -json | jq -r '.Module.Path')
TAG=`echo go/${ARTIFACT_NAME}/v${BASE_VERSION}`

RESULT=$(git tag -l ${TAG})
if [[ "$RESULT" != ${TAG}  && ${BASE_VERSION} != "0.0.0" ]]; then
    # Create tag
    echo "Creating a new release tag"
    ssh-agent sh -c 'ssh-add ~/.ssh/id_rsa;git tag -f ${TAG} ${CIRCLE_SHA1}'
    ssh-agent sh -c 'ssh-add ~/.ssh/id_rsa;git push origin ${TAG}'
fi