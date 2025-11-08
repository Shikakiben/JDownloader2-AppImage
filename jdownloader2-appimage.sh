#!/bin/bash
set -e

# Variables
ARCH="$(uname -m)"
PACKAGE="JDownloader2"
DATE="$(date +'%Y%m%d')"
OUTNAME="$PACKAGE-$DATE-$ARCH.AppImage"
UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"

# Téléchargement OpenJDK
mkdir -p jd2/jre
wget -O OpenJDK.tar.gz https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u402-b06/OpenJDK8U-jre_x64_linux_hotspot_8u402b06.tar.gz
tar -xzf OpenJDK.tar.gz --strip-components=1 -C jd2/jre

# Téléchargement JDownloader2
mkdir -p jd2
wget -O JD2Setup_x64.sh https://installer.jdownloader.org/JD2Setup_x64.sh
INSTALL4J_JAVA_HOME="$PWD/jd2/jre" xvfb-run -a bash JD2Setup_x64.sh -q -dir "${PWD}/jd2"

# Préparation AppDir
mkdir -p AppDir/bin AppDir/jd2
cp jd2/JDownloader2 AppDir/jd2/JDownloader2
cp -r jd2/* AppDir/jd2/
# Récupération dynamique du .desktop et de l'icône
cp "jd2/JDownloader 2.desktop" AppDir/JDownloader2.desktop
cp "jd2/.install4j/JDownloader2.png" AppDir/.DirIcon
cp bin/JDownloader2 AppDir/bin/JDownloader2
# S'assurer que le lanceur est exécutable
chmod +x AppDir/bin/JDownloader2
# Crée AppRun pour AppImage
cat > AppDir/AppRun <<'EOF'
#!/bin/sh
HERE="$(dirname "$(readlink -f "$0")")"
exec "$HERE/bin/JDownloader2" "$@"
EOF
chmod +x AppDir/AppRun

# Construction AppImage
wget -O quick-sharun.sh https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/main/useful-tools/quick-sharun.sh
chmod +x quick-sharun.sh
export UPINFO
export OUTNAME
export STARTUPWMCLASS=JDownloader2
export VERSION="$DATE"
./quick-sharun.sh --make-appimage

# Préparation pour release
mkdir -p dist
mv -v ./*.AppImage* dist/
echo "$DATE" > dist/version

