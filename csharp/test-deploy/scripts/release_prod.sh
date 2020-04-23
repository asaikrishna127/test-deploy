#!/usr/bin/env bash
echo "Release prod artifact"
BASE_VERSION=$(xmllint --xpath "//Project/PropertyGroup/Version/text()" Directory.Build.props)
echo ${BASE_VERSION}

export NUGET_SOURCE=$1
dotnet pack -c Release --no-build

find . -name *${BASE_VERSION}.nupkg  | xargs -L1 -I '{}' dotnet nuget push {} -k ${NUGET_KEY} -s ${NUGET_SOURCE}

# Bump master
git checkout master
MINOR_VERSION=`echo $BASE_VERSION | cut -f2 -d.`
NEW_BASE_VERSION=`echo $BASE_VERSION | cut -f1 -d.`.$((${MINOR_VERSION}+1)).0
dotnet tool install -g dotnet-setversion
export PATH="$PATH:/root/.dotnet/tools"
setversion "${NEW_BASE_VERSION}-alpha" Directory.Build.props
git add Directory.Build.props
git commit -m "Master version bump to ${NEW_BASE_VERSION}-alpha [skip ci]"
