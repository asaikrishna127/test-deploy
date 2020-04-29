#!/usr/bin/env bash
set -e

echo "Deploying snapshot"
FULL_VERSION=$(xmllint --xpath "//Project/PropertyGroup/Version/text()" Directory.Build.props)
echo ${FULL_VERSION}

TIME_STAMP=$(date "+%Y%m%d%H%M%S")
PACKAGE_VERSION=${FULL_VERSION}.${TIME_STAMP}

export NUGET_SOURCE=$1
dotnet pack -c Release -p:PackageVersion=${PACKAGE_VERSION} --no-build

find . -name *${PACKAGE_VERSION}.nupkg  | xargs -L1 -I '{}' dotnet nuget push {} -k ${NUGET_KEY} -s ${NUGET_SOURCE}