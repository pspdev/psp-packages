#!/bin/bash

#Change directory to the directory of this script
cd "$(dirname "$0")"
mkdir -p repo

# Export all variables
set -a

# Fail on error
set -e

# Set global variables
GITHUB_REPOSITORY_OWNER="${GITHUB_REPOSITORY_OWNER:-pspdev}"
GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-pspdev/psp-packages}"
INDEX_TABLE_CONTENT=""

# Build the html pages
for PSPBUILD in $(find . -maxdepth 2 -name "PSPBUILD"  | sort); do
  		# Make sure optional variables are from current PSPBUILD
  		unset groups
    		unset license
      		unset depends

		source "${PSPBUILD}"
		UPDATED=$(git log -1 --format=%cd --date=short -- "${PSPBUILD}")
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
