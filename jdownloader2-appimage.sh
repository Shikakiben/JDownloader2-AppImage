#!/bin/bash
set -e

# Téléchargement JDownloader2
mkdir -p jd2
wget -O JD2Setup_x64.sh https://installer.jdownloader.org/JD2Setup_x64.sh
bash JD2Setup_x64.sh -q -dir jd2

# Téléchargement OpenJDK
mkdir -p jd2/jre
wget -O OpenJDK.tar.gz https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10+7/OpenJDK17U-jre_x64_linux_hotspot_17.0.10_7.tar.gz
tar -xzf OpenJDK.tar.gz --strip-components=1 -C jd2/jre

# Préparation AppDir
mkdir -p AppDir/bin
cp jd2/JDownloader2 AppDir/jd2/JDownloader2
cp -r jd2/* AppDir/jd2/
# Récupération dynamique du .desktop et de l'icône
cp "jd2/JDownloader 2.desktop" AppDir/JDownloader2.desktop
cp "jd2/.install4j/JDownloader2.png" AppDir/.DirIcon
cp bin/JDownloader2 AppDir/bin/JDownloader2

# Construction AppImage
wget -O quick-sharun.sh https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/main/useful-tools/quick-sharun.sh
chmod +x quick-sharun.sh
VERSION=${VERSION:-dev} ./quick-sharun.sh --make-appimage
mkdir -p dist
mv JDownloader_2-*-x86_64.AppImage dist/

