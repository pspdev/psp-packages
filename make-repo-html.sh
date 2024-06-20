#!/bin/bash

mkdir -p repo
export GITHUB_REPOSITORY_OWNER="${GITHUB_REPOSITORY_OWNER:-pspdev}"
export GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-pspdev/pspdev}"

declare -a INDEX_TABLE_CONTENT
for PSPBUILD in $(find . -name "PSPBUILD" | sort); do
		source "${PSPBUILD}"
		UPDATED=$(git log -1 --format=%cd --date=short -- "${PSPBUILD}")
		URL="${pkgname}-${pkgver}-${pkgrel}-${arch}.pkg.tar.gz"
		INDEX_TABLE_CONTENT+=("<tr><td><a href=\"${pkgname}.html\">${pkgname}</a></td><td>${pkgver}-${pkgrel}</td><td>${pkgdesc}</td><td>${UPDATED}</td></tr>")
done

ensubst < index.html > repo/index.html

