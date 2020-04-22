#!/usr/bin/env bash
echo "Deploying snapshot"
BASE_VERSION=$(xmllint --xpath "//Project/PropertyGroup/Version/text()" Directory.Build.props)
echo ${BASE_VERSION}

export NUGET_SOURCE=$1
dotnet pack -c Release --no-build

find . -name *${BASE_VERSION}.nupkg  | xargs -L1 -I '{}' dotnet nuget push {} -k ${NUGET_KEY} -s ${NUGET_SOURCE}