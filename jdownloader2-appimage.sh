#!/bin/bash
set -euo pipefail

ARCH="$(uname -m)"
DATE_HUMAN="$(date +'%y.%m.%d')"
OUTNAME="JDownloader2-$DATE_HUMAN-$ARCH.AppImage"

APPDIR="$PWD/AppDir"

	rm -rf "$APPDIR/jre"

	# Téléchargement du JRE à embarquer (archive tar.gz) via API Adoptium
	JRE_API_URL="https://api.adoptium.net/v3/assets/latest/25/hotspot?architecture=x64&heap_size=normal&image_type=jre&jvm_impl=hotspot&os=linux&vendor=adoptium"
	JRE_TGZ="$APPDIR/jre.tar.gz"
	if [ ! -f "$JRE_TGZ" ]; then
		echo "Récupération de l'URL du JRE via l'API Adoptium..."
		if ! command -v jq >/dev/null 2>&1; then
			echo "Erreur : jq est requis pour parser l'API Adoptium." >&2
			exit 99
		fi
		JRE_URL=""
		for retry in {1..10}; do
			if command -v wget >/dev/null 2>&1; then
				JRE_JSON=$(wget -qO- "$JRE_API_URL" || printf '')
			else
				JRE_JSON=$(curl -sSL "$JRE_API_URL" || printf '')
			fi
			JRE_URL=$(printf '%s' "$JRE_JSON" | jq -r '.[0].binary.package.link')
			if [ -n "$JRE_URL" ] && [ "$JRE_URL" != "null" ]; then
				break
			fi
			echo "Échec récupération API Adoptium (tentative $retry/10), nouvelle tentative dans 5s..." >&2
			sleep 5
		done
		if [ -z "$JRE_URL" ] || [ "$JRE_URL" = "null" ]; then
			echo "Erreur : impossible d'obtenir l'URL du JRE via l'API Adoptium après 10 tentatives." >&2
			exit 99
		fi
		echo "Téléchargement du JRE embarqué depuis $JRE_URL ..."
		wget --retry-connrefused --tries=30 -O "$JRE_TGZ" "$JRE_URL"
	fi

wget --retry-connrefused --tries=30 -O "$APPDIR/JDownloader.jar" https://installer.jdownloader.org/JDownloader.jar

mkdir -p "$APPDIR/bin" "$APPDIR/shared/bin"
ln -sf ../JDownloader2 "$APPDIR/bin/JDownloader2"
ln -sf ../../JDownloader2 "$APPDIR/shared/bin/JDownloader2"

export OUTNAME
export JD2_APPIMAGE_BUILD=1
export JD2_APPIMAGE_BUNDLE_DIR="$APPDIR"
export XDG_DATA_HOME="$APPDIR/.xdg-data"
export XDG_CONFIG_HOME="$APPDIR/.xdg-config"
export OUTPUT_APPIMAGE=1

mkdir -p "$XDG_DATA_HOME" "$XDG_CONFIG_HOME"

cleanup() {
	rm -rf "$XDG_DATA_HOME" "$XDG_CONFIG_HOME"
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
