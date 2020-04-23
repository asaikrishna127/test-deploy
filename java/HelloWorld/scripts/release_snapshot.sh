#!/usr/bin/env bash
echo "Deploying snapshot"
mvn -DskipTests -s ../../.circleci/settings.xml deploy