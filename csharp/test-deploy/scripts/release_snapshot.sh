#!/usr/bin/env bash
echo "Deploying snapshot"
BASE_VERSION=$(xmllint --xpath "//Project/PropertyGroup/Version/text()" Directory.Build.props)
echo ${BASE_VERSION}

export NUGET_SOURCE=$1
dotnet pack -c Release --no-build

# Delete existing packages from nuget to support updating -alpha builds and idempotency for others (i.e. mimic mvn deploy semantics).
# This is some ugly bash magic to split package name and version tuples to pipe them properly into dotnet nuget delete.
find . -name *${BASE_VERSION}.nupkg  | xargs -L1 -I '{}' dotnet nuget delete {} -k ${NUGET_KEY} -s ${NUGET_SOURCE}
find . -name *${BASE_VERSION}.nupkg  | xargs -L1 -I '{}' dotnet nuget push {} -k ${NUGET_KEY} -s ${NUGET_SOURCE}