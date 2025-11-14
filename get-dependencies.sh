#!/bin/sh

set -eux

ARCH="$(uname -m)"

echo "Installing build dependencies for sharun & AppImage integration..."
echo "---------------------------------------------------------------"

pacman -Syu --noconfirm \
	base-devel \
	curl \
	desktop-file-utils \
	git \
	libxtst \
	wget \
	xorg-server-xvfb \
	zsync
    p7zip \
    gzip \
    which \
    jq
   

echo "Installing the app & it's dependencies..."
echo "---------------------------------------------------------------"

JDOWNLOADER_JAR="https://installer.jdownloader.org/JDownloader.jar"
JRE_API_URL="https://api.adoptium.net/v3/assets/latest/25/hotspot?architecture=x64&heap_size=normal&image_type=jre&jvm_impl=hotspot&os=linux&vendor=adoptium"
JRE_URL=$(wget -qO- --retry-connrefused --tries=30 "$JRE_API_URL" | jq -r '.[0].binary.package.link')

wget --retry-connrefused --tries=30 "$JDOWNLOADER_JAR -0 ./JDownloader.jar
wget --retry-connrefused --tries=30 "$JRE_URL" -O ./jre.tar.gz 


echo "Installing debloated packages..."
echo "---------------------------------------------------------------"

DEBLOATED_PKGS_INSTALLER="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/get-debloated-pkgs.sh"

wget --retry-connrefused --tries=30 "$DEBLOATED_PKGS_INSTALLER" -O ./get-debloated-pkgs.sh
chmod +x ./get-debloated-pkgs.sh
./get-debloated-pkgs.sh libxml2-mini mesa-nano gtk4-mini gdk-pixbuf2-mini librsvg-mini opus-mini
