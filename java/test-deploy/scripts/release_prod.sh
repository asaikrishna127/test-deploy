#!/usr/bin/env bash
FULL_VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version)
BASE_VERSION=`echo ${FULL_VERSION} | cut -f1 -d'-'`
TAG_NAME=$(git tag -l --points-at HEAD | tr -d [:alpha:])

if [[ "${TAG_NAME}" == ""  || "${TAG_NAME}" != "${BASE_VERSION}" ]]; then
    mvn versions:set versions:commit -DnewVersion="${BASE_VERSION}"
    TAG="v${BASE_VERSION}"
    git tag -f ${TAG}
    git push origin ${TAG}
    mvn clean deploy -Prelease
    if [[ "$?" != "0" ]]; then
        git tag -d ${TAG}
        git push --delete origin ${TAG}
    else
        mvn versions:set versions:commit -DnewVersion="${FULL_VERSION}"
    fi
fi
