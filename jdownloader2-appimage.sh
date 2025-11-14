#!/bin/sh

set -eux

ARCH="$(uname -m)"
VERSION="$(date +'%y.%m.%d')"
SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"

# Variables used by quick-sharun
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export OUTNAME=JDownloader2-"$VERSION"-anylinux-"$ARCH".AppImage
export JD2_APPIMAGE_BUILD=1

# Trace and deploy all files and directories needed for the application (including binaries, libraries and others)
wget --retry-connrefused --tries=30 "$SHARUN" -O ./quick-sharun
chmod +x ./quick-sharun
./quick-sharun /AppDir/bin/JDownloader2 /AppDir/JDownloader.jar /AppDir/jre.tar.gz

# Make the AppImage with uruntime
./quick-sharun --make-appimage

# Prepare the AppImage for release
mkdir -p ./dist
mv -v ./*.AppImage* ./dist
