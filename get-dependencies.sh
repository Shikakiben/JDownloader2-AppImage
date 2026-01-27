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
	jre-openjdk
	
    

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME


# If the application needs to be manually built that has to be done down here

wget --retry-connrefused --tries=30 "https://installer.jdownloader.org/JDownloader.jar" -O ./AppDir/bin/JDownloader.jar
