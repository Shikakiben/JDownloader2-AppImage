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
wget -O OpenJDK.tar.gz https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.3%2B9/OpenJDK21U-jre_x64_linux_hotspot_21.0.3_9.tar.gz
tar -xzf OpenJDK.tar.gz --strip-components=1 -C jd2/jre

# Préparation installation JDownloader2 (le script est versionné dans le dépôt)
mkdir -p jd2
INSTALLER_PATH="${PWD}/JDownloader2Setup_unix_nojre.sh"
if [ ! -x "$INSTALLER_PATH" ]; then
	chmod +x "$INSTALLER_PATH"
fi
INSTALL_DIR="${PWD}/jd2/install"
mkdir -p "$INSTALL_DIR"
INSTALL4J_JAVA_HOME="$PWD/jd2/jre" xvfb-run -a bash "$INSTALLER_PATH" -q -dir "$INSTALL_DIR"

# Déplacer l'installation effective dans jd2/ sans conserver de dossier avec espaces
if [ -d "jd2/install" ]; then
	if [ -d "jd2/install/JDownloader 2" ]; then
		src_dir="jd2/install/JDownloader 2"
	elif [ -d "jd2/install/JDownloader2" ]; then
		src_dir="jd2/install/JDownloader2"
	else
		src_dir="jd2/install"
	fi
	cp -a "$src_dir"/. jd2/
	rm -rf jd2/install
fi

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

