#!/bin/sh

set -eux

ARCH="$(uname -m)"

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"

pacman -Syu --noconfirm \
	base-devel \
	desktop-file-utils \
	git \
	libxtst \
	wget \
	zsync \
    jq \
	jre-openjdk \
	xorg-server-xvfb
    

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME


# If the application needs to be manually built that has to be done down here

chmod +x ./JDownloader2Setup_unix_nojre.sh
xvfb-run ./JDownloader2Setup_unix_nojre.sh

#mkdir -p ./AppDir/bin
cp -rv "$HOME/jd2"/* ./AppDir/bin/