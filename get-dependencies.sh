#!/bin/sh

set -eux

ARCH="$(uname -m)"

echo "Installing build dependencies for sharun & AppImage integration..."
echo "---------------------------------------------------------------"

pacman -Syu --noconfirm \
	base-devel \
	desktop-file-utils \
	git \
	libxtst \
	wget \
	zsync \
    jq
   

echo "Installing the app & it's dependencies..."
echo "---------------------------------------------------------------"

JDOWNLOADER_JAR="https://installer.jdownloader.org/JDownloader.jar"

if [ "$ARCH" = "x86_64" ]; then
	JRE_API_URL="https://api.adoptium.net/v3/assets/latest/25/hotspot?architecture=x64&heap_size=normal&image_type=jre&jvm_impl=hotspot&os=linux&vendor=adoptium"
elif [ "$ARCH" = "aarch64" ]; then
	JRE_API_URL="https://api.adoptium.net/v3/assets/latest/25/hotspot?architecture=aarch64&heap_size=normal&image_type=jre&jvm_impl=hotspot&os=linux&vendor=adoptium"
fi

JRE_URL=$(wget -qO- --retry-connrefused --tries=30 "$JRE_API_URL" | jq -r '.[0].binary.package.link')

wget --retry-connrefused --tries=30 "$JDOWNLOADER_JAR" -O ./AppDir/JDownloader.jar
wget --retry-connrefused --tries=30 "$JRE_URL" -O ./AppDir/jre.tar.gz 

