#!/usr/bin/env bash

REPO=`git remote -v | grep origin | grep fetch | awk '{print $2}'`
FULL_VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version)
BASE_VERSION=`echo ${FULL_VERSION} | cut -f1 -d'-'`
BRANCH="release-${BASE_VERSION}"

git ls-remote --exit-code --heads ${REPO} ${BRANCH} > /dev/null
if [[ "$?" == "2" ]]; then
    mvn release:branch -DbranchName=${BRANCH}
    git checkout -b "${BRANCH}"
else
   git fetch ${REPO} ${BRANCH}
   git checkout "${BRANCH}"
   FULL_VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version)
   RC=$(echo "$FULL_VERSION" | cut -f2 -d'-' | tr -d [:alpha:])
   NEW_VERSION="${BASE_VERSION}-rc$((${RC}+1))"
fi

TAG="v${NEW_VERSION}"
git tag -f ${TAG}
git push origin "${BRANCH}"
git push origin ${TAG}