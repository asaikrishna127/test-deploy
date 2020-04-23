#!/usr/bin/env bash
echo "Release prod artifact"
BASE_VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version)
ARTIFACT_NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.artifactId)
TAG=`echo java/${ARTIFACT_NAME}/v${BASE_VERSION}`

echo ${PRIVATE_GPG_KEY} | base64 --decode | gpg --batch --no-tty --import --yes

mvn -DskipTests -s ../../.circleci/settings.xml deploy -Prelease

# Create tag
git tag -f ${TAG}
git push origin ${TAG}