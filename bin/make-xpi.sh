#!/bin/bash

set -u

myRoot="${PWD}"

if [ -d "${myRoot}/src" ] ; then
	pushd "${myRoot}/src"
elif [ -d "${myRoot}/../src" ] ; then
	pushd "${myRoot}/../src" 
else
	echo "I'm lost."
	exit 2
fi

if [ -z "$(which zip)" ] ; then
	echo "We need the zip tool to do this."
	exit 2
fi

if [ ! -e ../CurrVers ] ; then
	{
		echo "VERS=1"
		echo "REL=4"
		echo "BRANCH=0"
		echo "PATCH=0"
	} > ../CurrVers
fi

. ../CurrVers

((BRANCH+=1))

{
	echo "VERS=${VERS}"
	echo "REL=${REL}"
	echo "BRANCH=${BRANCH}"
	echo "PATCH=${PATCH}"
} > ../CurrVers

echo "Updating version string."
sed -e "s@<em:version>VERS</em:version>@<em:version>${VERS}.${REL}.${BRANCH}.${PATCH}</em:version>@" < ../install.rdf > install.rdf

echo "New version is: ${VERS}.${REL}.${BRANCH}.${PATCH}"

zip -rq ../dist/thunderbird_message_filter_import_export.xpi *

/bin/ls -l ../dist/
