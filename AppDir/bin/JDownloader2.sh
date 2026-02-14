#!/bin/sh

JDDIR="$HOME/.local/share/JDownloader2"
LOGODIR="$JDDIR/themes/standard/org/jdownloader/images/logo"

if [ ! -s "$JDDIR/JDownloader.jar" ]; then
    rm -rf "$JDDIR/JDownloader.jar" "$JDDIR/Core.jar" "$JDDIR/update" "$JDDIR/tmp" 2>/dev/null
    mkdir -p "$JDDIR"
    install -m644 "$(dirname "$0")/JDownloader.jar" "$JDDIR/JDownloader.jar"

	if pgrep -x gnome-shell >/dev/null 2>&1 || [ "${XDG_CURRENT_DESKTOP:-}" = "GNOME" ] || [ "${DESKTOP_SESSION:-}" = "gnome" ]; then

	    # 1er lancement pour laisser JD créer son arborescence
	    java -jar "$JDDIR/JDownloader.jar" "$@" &
	    PID=$!

	    # attendre max 5 min que le dossier/logo existe
	    i=0
	    while [ $i -lt 150 ]; do
		if [ -d "$LOGODIR" ] && [ -f "$LOGODIR/jd_logo_128_128.png" ]; then
		    break
		fi
		sleep 2
		i=$((i+1))
	    done

	    # arrêter ce 1er run (sans tuer le script launcher)
	    kill "$PID" 2>/dev/null || true
	    pgrep -f "java .*${JDDIR}/JDownloader.jar" | xargs -r kill 2>/dev/null || true

	    # attendre l'arrêt complet des process JD (max 20s)
	    i=0
	    while pgrep -f "java .*${JDDIR}/JDownloader.jar" >/dev/null 2>&1 && [ $i -lt 20 ]; do
		sleep 1
		i=$((i+1))
	    done
	fi
fi

# copie icone systray if gnome
if pgrep -x gnome-shell >/dev/null 2>&1 || [ "${XDG_CURRENT_DESKTOP:-}" = "GNOME" ] || [ "${DESKTOP_SESSION:-}" = "gnome" ]; then
    install -m644 "$(dirname "$0")/jd_logo_128_128.png" "$LOGODIR/jd_logo_128_128.png"
fi

exec java -jar "$JDDIR/JDownloader.jar" "$@"
