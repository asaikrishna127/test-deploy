#!/usr/bin/env bash
set -e

echo "Deploying snapshot"
mvn -DskipTests -s ../../.circleci/settings.xml deploy