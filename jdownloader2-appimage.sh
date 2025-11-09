#!/bin/bash
set -e

# Variables
ARCH="$(uname -m)"
PACKAGE="JDownloader2"
DATE="$(date +'%Y%m%d')"
DATE_HUMAN="$(date +'%y.%m.%d')"
OUTNAME="$PACKAGE-$DATE_HUMAN-$ARCH.AppImage"
UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"

ensure_python3() {
	if command -v python3 >/dev/null 2>&1; then
		return
	fi

	echo "python3 not found; attempting to install it..." >&2

	install_cmd() {
		if [ "$(id -u)" -eq 0 ]; then
			"$@"
		elif command -v sudo >/dev/null 2>&1; then
			sudo "$@"
		else
			echo "Cannot install python3 automatically (need root privileges)." >&2
			return 1
		fi
	}

	if command -v pacman >/dev/null 2>&1; then
		install_cmd pacman -Sy --noconfirm --needed python
	elif command -v apt-get >/dev/null 2>&1; then
		install_cmd apt-get update
		install_cmd apt-get install -y python3
	elif command -v dnf >/dev/null 2>&1; then
		install_cmd dnf install -y python3
	elif command -v zypper >/dev/null 2>&1; then
		install_cmd zypper --non-interactive install python3
	elif command -v apk >/dev/null 2>&1; then
		install_cmd apk add --no-cache python3
	else
		echo "Unsupported package manager; please install python3 manually." >&2
		return 1
	fi

	if ! command -v python3 >/dev/null 2>&1; then
		echo "python3 installation failed." >&2
		return 1
	fi
}

# Téléchargement OpenJDK
mkdir -p jd2/jre
wget -O OpenJDK.tar.gz https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.3%2B9/OpenJDK21U-jre_x64_linux_hotspot_21.0.3_9.tar.gz
tar -xzf OpenJDK.tar.gz --strip-components=1 -C jd2/jre

# Téléchargement JDownloader2
mkdir -p jd2
wget -O JD2Setup_x64.sh https://installer.jdownloader.org/JD2Setup_x64.sh
ensure_python3
INSTALL4J_JAVA_HOME="$PWD/jd2/jre" xvfb-run -a bash JD2Setup_x64.sh -q -dir "${PWD}/jd2"

# Patch du lanceur install4j pour supporter les JVM récentes (>= 9)
python3 - <<'PY'
from pathlib import Path

launcher = Path("jd2/JDownloader2")
text = launcher.read_text()
needle = """  if [ "$ver_major" -gt "2" ]; then\n    return;\n  elif [ "$ver_major" -eq "2" ]; then\n    if [ "$ver_minor" -gt "0" ]; then\n      return;\n    fi\n  fi"""
replacement = """  if [ "$ver_major" -gt "2" ]; then\n    if [ "$ver_major" -lt "9" ]; then\n      return;\n    fi\n  elif [ "$ver_major" -eq "2" ]; then\n    if [ "$ver_minor" -gt "0" ]; then\n      return;\n    fi\n  fi"""

if needle not in text:
	raise SystemExit("Erreur : Impossible de patcher JDownloader2, bloc de version introuvable.")

patched = text.replace(needle, replacement)
patched = patched.replace(
	"  echo The version of the JVM must be at least 1.6 and at most 2.0.\n",
	'  echo "The version of the JVM must be at least 1.6."\n  echo "Modern JVM releases (9+) are supported in this AppImage build."\n',
)
patched = patched.replace(
	"  echo The version of the JVM must be at least 1.6.\n  echo Modern JVM releases (9+) are supported in this AppImage build.\n",
	'  echo "The version of the JVM must be at least 1.6."\n  echo "Modern JVM releases (9+) are supported in this AppImage build."\n',
)
launcher.write_text(patched)
PY

# Récupération de quick-sharun / sharun runtime
wget -O quick-sharun.sh https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/main/useful-tools/quick-sharun.sh
chmod +x quick-sharun.sh

# Préparer AppDir et y placer JDownloader avant l'exécution de quick-sharun
rm -rf AppDir
mkdir -p AppDir/jd2 AppDir/bin AppDir/shared/bin
cp -a jd2/. AppDir/jd2/
install -m 755 bin/JDownloader2 AppDir/bin/JDownloader2

# Préparation AppDir via quick-sharun pour injecter AppRun/sharun

DESKTOP_SRC="jd2/JDownloader 2.desktop"
DESKTOP_TMP="$PWD/JDownloader2.desktop"
cp "$DESKTOP_SRC" "$DESKTOP_TMP"
sed -i 's|^Exec=.*|Exec=JDownloader2|' "$DESKTOP_TMP"

ICON_PATH="$PWD/jd2/.install4j/JDownloader2.png"
chmod +x bin/JDownloader2

APPDIR="$PWD/AppDir" \
DESKTOP="$DESKTOP_TMP" \
ICON="$ICON_PATH" \
ADD_HOOKS="self-updater.bg.hook:fix-namespaces.hook" \
DEPLOY_DATADIR=0 \
DEPLOY_LOCALE=0 \
JD2_APPIMAGE_BUILD=1 \
./quick-sharun.sh "$PWD/bin/JDownloader2"

# quick-sharun/URuntime déploie lui-même le lanceur et l'environnement
# nécessaires (runtime sans FUSE) : inutile de télécharger un sharun séparé.

# Nettoyer les copies persistantes capturées par strace lors du déploiement
rm -rf AppDir/shared/lib/home

# Injecter les fichiers JDownloader dans l'AppDir générée
install -m 755 bin/JDownloader2 AppDir/shared/bin/JDownloader2
cp "$DESKTOP_TMP" AppDir/JDownloader2.desktop
cp "$ICON_PATH" AppDir/.DirIcon
rm -f "$DESKTOP_TMP"

# Construction AppImage
export UPINFO
export OUTNAME
export STARTUPWMCLASS=JDownloader
export VERSION="$DATE_HUMAN"
./quick-sharun.sh --make-appimage

# Préparation pour release
mkdir -p dist
mv -v ./*.AppImage* dist/
echo "$PACKAGE $DATE_HUMAN" > dist/version

