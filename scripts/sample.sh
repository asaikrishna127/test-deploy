#!/usr/bin/env bash

FULL_VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version)
BASE_VERSION=`echo ${FULL_VERSION} | cut -f1 -d'-'`
BRANCH="${BASE_VERSION}-rc1"

mvn release:branch -DbranchName=${BRANCH}

TAG="v${BRANCH}"
git tag -f ${TAG}
git push origin "${BRANCH}"
git push origin ${TAG}