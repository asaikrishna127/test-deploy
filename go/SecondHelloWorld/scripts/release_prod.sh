#!/usr/bin/env bash
echo "Release prod artifact"
BASE_VERSION=$(cat .version | jq -r .version)
ARTIFACT_NAME=$(go mod edit -json | jq -r '.Module.Path')
TAG=`echo go/${ARTIFACT_NAME}/v${BASE_VERSION}`

RESULT=$(git tag -l ${TAG})
if [[ "$RESULT" != ${TAG}  && ${BASE_VERSION} != "0.0.0" ]]; then
    # Create tag
    git tag -f ${TAG}
    git push origin ${TAG}
fi