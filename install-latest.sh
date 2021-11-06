#!/bin/bash
# install-latest.sh by fjtrujy

if [ -z "$1" ] 
then
    echo "Using default packages repo pspdev/psp-packages"
    PACKAGES_REPO="pspdev/psp-packages"
else
    PACKAGES_REPO=$1
fi

# https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8
curl -s https://api.github.com/repos/${PACKAGES_REPO}/releases/latest \
        | grep "browser_download_url.*pkg.tar.gz" \
        | cut -d : -f 2,3 \
        | tr -d \" \
        | wget -qi -

psp-pacman -U --noconfirm *.pkg.tar.gz --overwrite '*'