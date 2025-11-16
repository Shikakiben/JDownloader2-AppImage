#!/bin/sh

set -eux

ARCH="$(uname -m)"
VERSION=$(pacman -Q JDownloader2 | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export JD2_APPIMAGE_BUILD=1

# Deploy dependencies
./quick-sharun /AppDir/bin/JDownloader2 /AppDir/JDownloader.jar /AppDir/jre.tar.gz

# Make the AppImage with uruntime
./quick-sharun --make-appimage
