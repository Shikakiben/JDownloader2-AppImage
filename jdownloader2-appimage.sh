#!/bin/bash
set -euo pipefail

ARCH="$(uname -m)"
DATE_HUMAN="$(date +'%y.%m.%d')"
OUTNAME="JDownloader2-$DATE_HUMAN-$ARCH.AppImage"

APPDIR="$PWD/AppDir"

rm -rf "$APPDIR/jre"

wget --retry-connrefused --tries=30 -O "$APPDIR/JDownloader.jar" https://installer.jdownloader.org/JDownloader.jar

mkdir -p "$APPDIR/bin" "$APPDIR/shared/bin"
ln -sf ../JDownloader2 "$APPDIR/bin/JDownloader2"
ln -sf ../../JDownloader2 "$APPDIR/shared/bin/JDownloader2"

export OUTNAME
export JD2_APPIMAGE_BUILD=1
export JD2_APPIMAGE_BUNDLE_DIR="$APPDIR"
export JD2_APPIMAGE_DATA_DIR="$APPDIR/.persist"
export XDG_DATA_HOME="$APPDIR/.xdg-data"
export XDG_CONFIG_HOME="$APPDIR/.xdg-config"
export OUTPUT_APPIMAGE=1

mkdir -p "$JD2_APPIMAGE_DATA_DIR" "$XDG_DATA_HOME" "$XDG_CONFIG_HOME"

cleanup() {
	rm -rf "$JD2_APPIMAGE_DATA_DIR" "$XDG_DATA_HOME" "$XDG_CONFIG_HOME"
}
trap cleanup EXIT

wget --retry-connrefused --tries=30 "https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/main/useful-tools/quick-sharun.sh" -O ./quick-sharun
chmod +x ./quick-sharun

./quick-sharun "$APPDIR/JDownloader2"

if [ ! -f "$OUTNAME" ]; then
	echo "Erreur : l'AppImage attendue $OUTNAME est introuvable." >&2
	exit 3
fi

mkdir -p dist
mv -f "$OUTNAME" "dist/$OUTNAME"

echo "AppImage JDownloader2 généré : dist/$OUTNAME"

if command -v zsyncmake >/dev/null 2>&1; then
	zsyncmake -o "dist/$OUTNAME.zsync" "dist/$OUTNAME"
    echo "Fichier zsync généré : dist/$OUTNAME.zsync"
else
    echo "zsyncmake non trouvé, zsync non généré" >&2
fi