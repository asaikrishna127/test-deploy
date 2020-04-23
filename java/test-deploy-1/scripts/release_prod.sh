#!/usr/bin/env bash
echo "Release prod artifact"
BASE_VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version)
echo ${BASE_VERSION}

echo ${PRIVATE_GPG_KEY} | base64 --decode | gpg --batch --no-tty --import --yes

mvn -DskipTests -s ../../.circleci/settings.xml deploy -Prelease

# Bump master
git checkout master
git pull origin master
MINOR_VERSION=`echo ${BASE_VERSION} | cut -f2 -d.`
NEW_BASE_VERSION=`echo ${BASE_VERSION} | cut -f1 -d.`.$((${MINOR_VERSION}+1)).0
mvn versions:set versions:commit -DnewVersion="${NEW_BASE_VERSION}-SNAPSHOT"
git add pom.xml
git commit -m "Master version bump to ${NEW_BASE_VERSION}-SNAPSHOT [ci skip]"
git push origin master