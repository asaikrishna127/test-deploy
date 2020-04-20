#!/usr/bin/env bash
echo "Deploying snapshot"
mvn -DskipTests -s ../../.circleci/settings.xml deploy


echo ${PRIVATE_GPG_KEY} | base64 --decode | gpg --batch --no-tty --import --yes
