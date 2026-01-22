#!/bin/bash

#Change directory to the directory of this script
cd "$(dirname "$0")"
mkdir -p repo

# Export all variables
set -a

# Fail on error
set -e

# Set global variables
PKGBUILD_NAME="PSPBUILD"
GITHUB_REPOSITORY_OWNER="${GITHUB_REPOSITORY_OWNER:-pspdev}"
GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-pspdev/psp-packages}"
PACKAGES="$(find . -maxdepth 2 -name "${PKGBUILD_NAME}" | sort)"
PACKAGE_COUNT="$(echo ${PACKAGES} | wc -w)"
INDEX_TABLE_CONTENT=""

function createSourceLink() {
	src="${1}"
	pkgname="${2}"
	if [[ ${1} == git+* ]]; then
		BASE_URL="$(echo $1 | cut -d'+' -f2- | rev | cut -d'.' -f2- | rev)" 
		if [[ ${1} == *.git#commit=* ]]; then
			COMMIT="$(echo $1 | cut -d'=' -f2)"
			URL="${BASE_URL}/tree/${COMMIT}"
			echo "<a href=\"${URL}\">${BASE_URL}</a>"
		elif [[ ${1} == *.git#branch=* ]]; then
			BRANCH="$(echo $1 | cut -d'=' -f2)"
			URL="${BASE_URL}/tree/${BRANCH}"
			echo "<a href=\"${URL}\">${BASE_URL}</a>"
		else
			echo "<a href=\"${BASE_URL}\">${BASE_URL}</a>"
		fi
	elif [[ ${1} == http?://* ]] || [[ ${1} == ftp?://* ]]; then
			echo "<a href=\"${1}\">${1}</a>"
	else
		echo "<a href=\"https://github.com/${GITHUB_REPOSITORY}/blob/master/${pkgname}/${1}\">${1}</a>"
	fi
}

# Build the html pages
for PKGBUILD in ${PACKAGES}; do
  		# Make sure optional variables are from current PKGBUILD
  		unset groups
    		unset license
      		unset depends

		source "${PKGBUILD}"
		UPDATED=$(git log -1 --format=%cd --date=short -- "${PKGBUILD}")
		DOWNLOAD_URL="${pkgname}-${pkgver}-${pkgrel}-${arch}.pkg.tar.gz"

		# Convert lists to strings
		ARCH="${arch[*]}"
		LICENSE="${license[*]}"
		GROUP_LIST="${groups[*]}"

		# Get file size info
		FILENAME="repo/${DOWNLOAD_URL}"
		if [ -f "${FILENAME}" ]; then
  			PKGSIZE="$(ls -l  "${FILENAME}"|cut -d' ' -f5|numfmt --to iec --suffix=B --format "%.1f")"
			INSTSIZE="$(gunzip -c "${FILENAME}"|grep -a '^size = '|cut -d' ' -f3|numfmt --to iec --suffix=B --format "%.1f")"
		fi

		# List dependencies
		if [ ! -n "${depends[*]}" ]; then
			DEPS="No dependencies"
		else
			DEPS="<ul>"
			for dep in "${depends[@]}"; do
				DEPS="${DEPS}<li><a href=\"${dep}.html\">${dep}</a></li>"
			done
			DEPS="${DEPS}</ul>"
		fi

		# List dependencies
		if [ ! -n "${source[*]}" ]; then
			SOURCES="No sources"
		else
			SOURCES="<ul>"
			for src in "${source[@]}"; do
				SOURCES="${SOURCES}<li>$(createSourceLink "${src}" "${pkgname}")</li>"
			done
			SOURCES="${SOURCES}</ul>"
		fi

		# List content of files
		if [ -f "${FILENAME}" ]; then
			CONTENT="<ul>"
			for item in $(tar -tzf $FILENAME | grep -v '\.BUILDINFO\|\.MTREE\|\.PKGINFO\|/$'); do
				CONTENT="${CONTENT}<li>${item}</li>"
			done
			CONTENT="${CONTENT}</ul>"
		else
			CONTENT="Not known"
		fi

		envsubst < package.html > "repo/${pkgname}.html"

		INDEX_TABLE_CONTENT="${INDEX_TABLE_CONTENT}<tr><td><a href=\"${pkgname}.html\">${pkgname}</a></td><td>${pkgver}-${pkgrel}</td><td>${pkgdesc}</td><td>${GROUP_LIST}</td><td>${UPDATED}</td></tr>"
done

envsubst < index.html > repo/index.html
cp style.css repo/
