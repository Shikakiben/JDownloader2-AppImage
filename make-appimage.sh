#!/bin/sh

set -eux

ARCH="$(uname -m)"
VERSION="$(date +'%y.%m.%d')"
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"

# Deploy dependencies
quick-sharun \
        ./AppDir/bin/* \
        /usr/lib/jvm/java*/bin \
        /usr/lib/jvm/java*/conf \
        /usr/lib/jvm/java*/legal \
        /usr/lib/jvm/java*/lib
        #/usr/lib/jvm/java*/*

# Make the AppImage with uruntime
quick-sharun --make-appimage
