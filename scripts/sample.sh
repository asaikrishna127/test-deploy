#!/usr/bin/env bash

FULL_VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version)
BASE_VERSION=`echo ${FULL_VERSION} | cut -f1 -d'-'`
BRANCH="release-${BASE_VERSION}"

mvn release:branch -DbranchName=${BRANCH}